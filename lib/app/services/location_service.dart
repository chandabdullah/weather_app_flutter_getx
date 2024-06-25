import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class LocationService {
  LocationService._();

  static Future<permission_handler.PermissionStatus> get status =>
      permission_handler.Permission.location.status;

  static Future<LocationData?> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Check if the app has permission to access location
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    var locationData = await location.getLocation();

    return locationData;
  }
}
