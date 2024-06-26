import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:weather_app/app/environment/environment.dart';
import 'package:weather_app/app/models/weather_model.dart';
import 'package:weather_app/app/services/api_call_status.dart';
import 'package:weather_app/app/services/base_client.dart';
import 'package:weather_app/app/services/location_service.dart';

class HomeController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  Current? currentWeather;
  bool isLocationEnabled = false;

  getLocationData() async {
    await LocationService.enableLocationService();

    await LocationService.requestLocationPermission();

    var status = await LocationService.getPermissionStatus;
    print(status);

    if (status != PermissionStatus.granted) return;

    LocationData? location = await LocationService.getCurrentLocation();
    if (location == null) return;
    isLocationEnabled = true;
    update();

    print(location.latitude);
    print(location.longitude);

    getWeatherInfo(location.latitude, location.longitude);
  }

  getWeatherInfo(double? lat, double? lng) {
    BaseClient.safeApiCall(
      '${EnvironmentConfig.BASE_URL}/data/3.0/onecall',
      RequestType.get,
      queryParameters: {
        'lat': lat,
        'lon': lng,
        'units': 'metric',
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
