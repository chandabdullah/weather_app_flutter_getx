import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';

import '/app/models/cities_countries_model.dart';

class LocationService {
  LocationService._();

  static final Location location = Location();

  // =====================================================
  // PERMISSION
  // =====================================================

  static Future<PermissionStatus> get getPermissionStatus async {
    return await location.hasPermission();
  }

  static Future<PermissionStatus> requestLocationPermission() async {
    PermissionStatus permission = await location.hasPermission();

    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }

    return permission;
  }

  // =====================================================
  // SERVICE
  // =====================================================

  static Future<bool> enableLocationService() async {
    bool enabled = await location.serviceEnabled();

    if (!enabled) {
      enabled = await location.requestService();
    }

    return enabled;
  }

  // =====================================================
  // LOCATION
  // =====================================================

  static Future<LocationData?> getCurrentLocation() async {
    try {
      final serviceEnabled = await enableLocationService();

      if (!serviceEnabled) return null;

      final permission = await requestLocationPermission();

      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.grantedLimited) {
        return null;
      }

      return await location.getLocation();
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // GET CITY FROM LAT LNG (FIXED)
  // =====================================================

  static Future<City?> getCityFromLatLng(
    double lat,
    double lng,
  ) async {
    try {
      final placeMarks = await geocoding.placemarkFromCoordinates(
        lat,
        lng,
      );

      if (placeMarks.isEmpty) return null;

      final place = placeMarks.first;

      final cityName = _getBestCityName(place);

      return City(
        id: 0,
        city: cityName,
        country: place.country ?? "",
        lat: lat,
        lng: lng,
      );
    } catch (_) {
      return City(
        id: 0,
        city: "Unknown",
        country: "",
        lat: lat,
        lng: lng,
      );
    }
  }

  // =====================================================
  // BETTER CITY NAME FALLBACKS
  // =====================================================

  static String _getBestCityName(
    geocoding.Placemark place,
  ) {
    return place.locality?.trim().isNotEmpty == true
        ? place.locality!
        : place.subAdministrativeArea?.trim().isNotEmpty == true
            ? place.subAdministrativeArea!
            : place.administrativeArea?.trim().isNotEmpty == true
                ? place.administrativeArea!
                : place.subLocality?.trim().isNotEmpty == true
                    ? place.subLocality!
                    : "Unknown";
  }
}
