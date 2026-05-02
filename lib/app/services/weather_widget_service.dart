import 'package:flutter/services.dart';

import '/app/constants/app_constants.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/environment/environment.dart';
import '/app/models/weather_model.dart';

class WeatherWidgetService {
  static const MethodChannel _channel = MethodChannel('weather_widget');

  static Future<void> updateWidget({
    required WeatherModel weather,
    double? latitude,
    double? longitude,
    String? cityName,
  }) async {
    final current = weather.current;
    if (current == null) return;

    final city = cityName ?? MySharedPref.getCurrentCity()?.city ?? 'Weather';
    final currentWeather =
        current.weather?.isNotEmpty == true ? current.weather!.first : null;

    final payload = <String, dynamic>{
      'city': city,
      'latitude': latitude ?? weather.lat,
      'longitude': longitude ?? weather.lon,
      'apiBaseUrl': EnvironmentConfig.BASE_URL,
      'apiKey': EnvironmentConfig.API_KEY,
      'refreshAfterHours': apiCallAfter.inHours,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      'current': {
        'temp': current.temp,
        'feelsLike': current.feelsLike,
        'humidity': current.humidity,
        'windSpeed': current.windSpeed,
        'main': mainValues.reverse[currentWeather?.main] ?? 'Weather',
        'description':
            descriptionValues.reverse[currentWeather?.description] ?? 'Current',
      },
      'today': _todayForecast(weather),
    };

    try {
      await _channel.invokeMethod('updateWeatherWidget', payload);
    } on MissingPluginException catch (_) {
      // Android-only widget bridge is not available on other platforms.
    } on PlatformException catch (_) {
      // Widget updates are best-effort and should not interrupt app weather flow.
    }
  }

  static Map<String, dynamic> _todayForecast(WeatherModel weather) {
    final today =
        weather.daily?.isNotEmpty == true ? weather.daily!.first : null;
    final todayWeather =
        today?.weather?.isNotEmpty == true ? today!.weather!.first : null;

    return {
      'dt': today?.dt,
      'min': today?.temp?.min,
      'max': today?.temp?.max,
      'humidity': today?.humidity,
      'windSpeed': today?.windSpeed,
      'main': mainValues.reverse[todayWeather?.main] ?? 'Weather',
      'description':
          descriptionValues.reverse[todayWeather?.description] ?? 'Forecast',
    };
  }
}
