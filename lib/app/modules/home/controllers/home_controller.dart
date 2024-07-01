import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/app/constants/app_constants.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/environment/environment.dart';
import '/app/models/cities_countries_model.dart';
import '/app/models/weather_model.dart';
import '/app/services/api_call_status.dart';
import '/app/services/base_client.dart';
import '/app/services/location_service.dart';

class HomeController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  RefreshController smartRefreshController = RefreshController();

  String? currentCity;
  bool isLoadingLocation = false;
  bool isLocationEnabled = false;

  double? latitude;
  double? longitude;

  Current? currentWeather;
  List<Current> hourlyForecast = [];
  List<Daily> dailyForecast = [];

  getLocationData([bool onRefresh = false]) async {
    isLoadingLocation = true;
    true;

    City? currentLocalCity = MySharedPref.getCurrentCity();

    await LocationService.enableLocationService();

    await LocationService.requestLocationPermission();

    var status = await LocationService.getPermissionStatus;

    if (status != PermissionStatus.granted) {
      isLoadingLocation = false;
      isLocationEnabled = false;
      update();
      return;
    }

    LocationData? location = await LocationService.getCurrentLocation();
    if (location == null) {
      isLoadingLocation = false;
      isLocationEnabled = false;
      update();
      return;
    }
    if (location.latitude == null || location.longitude == null) {
      isLoadingLocation = false;
      isLocationEnabled = false;
      update();
      return;
    }

    latitude = location.latitude;
    longitude = location.longitude;
    // latitude = 34.0144;
    // longitude = 71.5675;
    // TODO:

    City? city = await LocationService.getCityFromLatLng(
      latitude ?? 0,
      longitude ?? 0,
    );
    currentCity = city?.city;
    MySharedPref.setCurrentCity(city ?? City());

    if (currentLocalCity == null) {
      isLocationEnabled = true;
      isLoadingLocation = false;
    } else {
      currentCity = currentLocalCity.city;
      latitude = currentLocalCity.lat;
      longitude = currentLocalCity.lng;

      isLocationEnabled = true;
      isLoadingLocation = false;
    }

    update();

    DateTime now = DateTime.now();
    DateTime? updatedDate = MySharedPref.getUpdateDate();

    if (updatedDate == null) {
      getWeatherInfo();
    } else {
      DateTime apiCallDate = updatedDate.add(apiCallAfter);

      Logger().i(
        "onRefresh: $onRefresh - "
        "API will call on ${DateFormat('hh:mm').format(apiCallDate)} but now it's ${DateFormat('hh:mm').format(now)}",
      );

      if ((now.isAfter(apiCallDate) || onRefresh)) {
        getWeatherInfo();
      } else {
        var response = MySharedPref.getTodaysWeather();
        currentWeather = response?.current;
        hourlyForecast = response?.hourly ?? [];
        dailyForecast = response?.daily ?? [];

        apiCallStatus = ApiCallStatus.success;
      }
    }

    update();
  }

  getWeatherInfo() {
    BaseClient.safeApiCall(
      '${EnvironmentConfig.BASE_URL}/data/3.0/onecall',
      RequestType.get,
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'units': 'metric',
        'exclude': 'minutely',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal()),
        'appid': EnvironmentConfig.API_KEY,
      },
      onError: (e) {
        apiCallStatus = ApiCallStatus.error;
        update();
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (resp) {
        var response = weatherModelFromJson(resp.data);
        currentWeather = response.current;
        hourlyForecast = response.hourly ?? [];
        dailyForecast = response.daily ?? [];

        MySharedPref.setTodaysWeather(response);
        MySharedPref.setUpdateDate(DateTime.now());

        apiCallStatus = ApiCallStatus.success;
        update();
      },
    );
  }

  @override
  void onInit() {
    getLocationData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
