// ===============================
// home_controller.dart
// Clean Professional Version
// ===============================

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '/app/constants/app_constants.dart';
import '/app/data/local/my_coordinates.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/environment/environment.dart';
import '/app/models/cities_countries_model.dart';
import '/app/models/weather_model.dart';
import '/app/services/api_call_status.dart';
import '/app/services/base_client.dart';
import '/app/services/connectivity_service.dart';
import '/app/services/location_service.dart';

class HomeController extends GetxController {
  // =====================================================
  // STATES
  // =====================================================

  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  bool isInitializing = true;
  bool isLoadingLocation = false;
  bool isLocationEnabled = true;
  bool isInternetConnected = true;

  // =====================================================
  // DATA
  // =====================================================

  RefreshController smartRefreshController = RefreshController();

  String? currentCity;

  double? latitude;
  double? longitude;

  Current? currentWeather;
  List<Current> hourlyForecast = [];
  List<Daily> dailyForecast = [];

  // ==================================================
  // Google Ads initalization
  // ==================================================
  BannerAd? bannerAd;
  bool isBannerLoaded = false;

  // =====================================================
  // APP START
  // =====================================================

  @override
  void onReady() async {
    super.onReady();
    await initializeApp();
    loadBannerAd();
  }

  loadBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-5729613540923747/3467449826',
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerLoaded = true;
          update();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Failed to load banner ad: ${error.message}");
        },
      ),
    );

    bannerAd?.load();
  }

  Future<void> initializeApp() async {
    isInitializing = true;
    update();

    isInternetConnected = await ConnectivityService.checkInternetConnectivity();

    if (!isInternetConnected) {
      final cache = MySharedPref.getTodaysWeather();

      if (cache != null) {
        saveResponse(cache);
      }

      isInitializing = false;
      update();
      return;
    }

    await getWeatherData();

    isInitializing = false;
    update();
  }

  // =====================================================
  // MAIN WEATHER FLOW
  // =====================================================

  Future<void> getWeatherData([bool onRefresh = false]) async {
    final cachedDate = MySharedPref.getUpdateDate();

    if (cachedDate == null) {
      await getLocationData();
      await getWeatherInfo();
      return;
    }

    final now = DateTime.now();
    final nextCall = cachedDate.add(apiCallAfter);

    if (now.isAfter(nextCall) || onRefresh) {
      await getLocationData();
      await getWeatherInfo();
    } else {
      final cache = MySharedPref.getTodaysWeather();

      if (cache != null) {
        saveResponse(cache);
      }
    }
  }

  // =====================================================
  // LOCATION
  // =====================================================

  Future<void> getLocationData() async {
    isLoadingLocation = true;
    update();

    await LocationService.enableLocationService();
    await LocationService.requestLocationPermission();

    final permission = await LocationService.getPermissionStatus;

    if (permission != PermissionStatus.granted) {
      isLocationEnabled = false;
      isLoadingLocation = false;
      update();
      return;
    }

    final location = await LocationService.getCurrentLocation();

    if (location == null ||
        location.latitude == null ||
        location.longitude == null) {
      isLocationEnabled = false;
      isLoadingLocation = false;
      update();
      return;
    }

    latitude = location.latitude;
    longitude = location.longitude;

    final city = await LocationService.getCityFromLatLng(
      latitude!,
      longitude!,
    );

    currentCity = city?.city ?? "Unknown";

    MySharedPref.setCurrentCity(city ?? City());

    isLocationEnabled = true;
    isLoadingLocation = false;
    update();
  }

  // =====================================================
  // API
  // =====================================================

  Future<void> getWeatherInfo() async {
    BaseClient.safeApiCall(
      EnvironmentConfig.BASE_URL,
      RequestType.get,
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'units': 'metric',
        'exclude': 'minutely',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'appid': EnvironmentConfig.API_KEY,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onError: (e) {
        apiCallStatus = ApiCallStatus.error;
        update();
      },
      onSuccess: (resp) {
        final response = weatherModelFromJson(resp.data);

        saveResponse(response);

        MySharedPref.setTodaysWeather(response);
        MySharedPref.setUpdateDate(DateTime.now());

        MyCoordinates.saveCoordinates(
          LocationData.fromMap({
            "latitude": latitude,
            "longitude": longitude,
          }),
        );
      },
    );
  }

  // =====================================================
  // SAVE RESPONSE
  // =====================================================

  void saveResponse(WeatherModel response) {
    currentWeather = response.current;

    hourlyForecast = response.hourly?.take(24).toList() ?? [];

    dailyForecast = response.daily ?? [];

    apiCallStatus = ApiCallStatus.success;
    isLocationEnabled = true;
    isLoadingLocation = false;

    update();
  }
}
