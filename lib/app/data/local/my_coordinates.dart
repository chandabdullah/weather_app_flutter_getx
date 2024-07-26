import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';

class MyCoordinates {
  static final GetStorage _storage = GetStorage();

  static const String _key_lat = 'my_lat';
  static const String _key_lng = 'my_lng';

  static saveCoordinates(LocationData coordinates) {
    _storage.write(_key_lat, coordinates.latitude);
    _storage.write(_key_lng, coordinates.longitude);
  }

  static LocationData? getCoordinates() {
    var latitude = _storage.read(_key_lat);
    var longitude = _storage.read(_key_lng);

    if (latitude == null || longitude == null) return null;

    LocationData coordinates = LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
    return coordinates;
  }
}
