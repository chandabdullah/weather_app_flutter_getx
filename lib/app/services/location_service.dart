import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:weather_app/app/models/cities_countries_model.dart';

class LocationService {
  LocationService._();
  static Location location = Location();

  static Future<PermissionStatus> get getPermissionStatus =>
      location.hasPermission();

  static Future<PermissionStatus> requestLocationPermission() async {
    PermissionStatus permissionGranted;
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      return permissionGranted;
    }
    return permissionGranted;
  }

  static Future<bool> enableLocationService() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      return serviceEnabled;
    }
    return serviceEnabled;
  }

  static Future<LocationData?> getCurrentLocation() async {
    Location location = Location();

    // Check if location services are enabled
    await enableLocationService();

    // Check if the app has permission to access location
    await requestLocationPermission();

    var locationData = await location.getLocation();

    return locationData;
  }

  static Future<City?> getCityFromLatLng(double lat, double lng) async {
    List<geocoding.Placemark> placeMarks =
        await geocoding.placemarkFromCoordinates(lat, lng);

    return City(
      id: 0,
      city: placeMarks.first.locality,
      country: placeMarks.first.country,
      lat: lat,
      lng: lng,
    );
  }
}
