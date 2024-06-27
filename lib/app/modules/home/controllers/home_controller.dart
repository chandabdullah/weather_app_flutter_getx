import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/app/constants/app_constants.dart';
import 'package:weather_app/app/data/local/my_shared_pref.dart';
import 'package:weather_app/app/environment/environment.dart';
import 'package:weather_app/app/models/cities_countries_model.dart';
import 'package:weather_app/app/models/weather_model.dart';
import 'package:weather_app/app/services/api_call_status.dart';
import 'package:weather_app/app/services/base_client.dart';
import 'package:weather_app/app/services/location_service.dart';

class HomeController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  RefreshController smartRefreshController = RefreshController();

  String? currentCity;
  bool isLocationEnabled = false;

  double? latitude;
  double? longitude;

  Current? currentWeather;
  List<Current> hourlyForecast = [];
  List<Daily> dailyForecast = [];

  getLocationData() async {
    // double? latitude;
    // double? longitude;

    City? currentLocalCity = MySharedPref.getCurrentCity();

    await LocationService.enableLocationService();

    await LocationService.requestLocationPermission();

    var status = await LocationService.getPermissionStatus;

    if (status != PermissionStatus.granted) return;

    LocationData? location = await LocationService.getCurrentLocation();
    if (location == null) return;

    isLocationEnabled = true;
    update();

    if (location.latitude == null || location.longitude == null) return;

    latitude = location.latitude;
    longitude = location.longitude;

    City? city = await LocationService.getCityFromLatLng(
      location.latitude ?? 0,
      location.longitude ?? 0,
    );
    currentCity = city?.city;
    MySharedPref.setCurrentCity(city ?? City());

    if (currentLocalCity == null) {
    } else {
      currentCity = currentLocalCity.city;
      latitude = currentLocalCity.lat;
      longitude = currentLocalCity.lng;
    }

    update();

    DateTime now = DateTime.now();
    DateTime? updatedDate = MySharedPref.getUpdateDate();

    if (updatedDate == null) {
      getWeatherInfo();
    } else {
      DateTime apiCallDate = updatedDate.add(apiCallAfter);

      Logger().i(
        "API will call on ${DateFormat('hh:mm').format(apiCallDate)} but now it's ${DateFormat('hh:mm').format(now)}",
      );

      if (now.isAfter(apiCallDate)) {
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
