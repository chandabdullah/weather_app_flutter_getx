import 'package:flutter/material.dart';
// import 'package:app/app/model/user_model.dart';
import 'package:get_storage/get_storage.dart';
import '/app/models/cities_countries_model.dart';
import '/app/models/weather_model.dart';
// import 'package:app/app/model/user_model.dart';

import '../../../config/translations/localization_service.dart';

class MySharedPref {
  // get storage
  static late final GetStorage _storage;

  // STORING KEYS
  // static const String _tokenKey = 'token';
  // static const String _userKey = 'user_key';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _todayWeatherKey = 'today_weather';
  static const String _updateDateKey = 'update_date';
  static const String _currentCityKey = 'current_city';

  /// init get storage services
  static init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  /// set theme current type as light theme
  static void setThemeIsLight(bool lightTheme) =>
      _storage.write(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _storage.read(_lightThemeKey) ??
      true; // todo set the default theme (true for light, false for dark)

  /// save current locale
  static void setCurrentLanguage(String languageCode) =>
      _storage.write(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal() {
    String? langCode = _storage.read(_currentLocalKey);
    // default language is english
    if (langCode == null) {
      return LocalizationService.defaultLanguage;
    }
    return LocalizationService.supportedLanguages[langCode]!;
  }

  static void clearSharePref() => _storage.erase();

  static void setTodaysWeather(WeatherModel weatherModel) {
    var weatherData = weatherModelToJson(weatherModel);
    _storage.write(_todayWeatherKey, weatherData);
  }

  static WeatherModel? getTodaysWeather() {
    var weatherData = _storage.read(_todayWeatherKey);
    if (weatherData == null) return null;
    return weatherModelFromJson(weatherData);
  }

  static setUpdateDate(DateTime dateTime) {
    var date = dateTime.toIso8601String();
    _storage.write(_updateDateKey, date);
  }

  static DateTime? getUpdateDate() {
    var date = _storage.read(_updateDateKey);
    if (date == null) return null;
    return DateTime.parse(date);
  }

  static setCurrentCity(City city) {
    var cityData = cityToJson(city);
    _storage.write(_currentCityKey, cityData);
  }

  static City? getCurrentCity() {
    var cityData = _storage.read(_currentCityKey);
    if (cityData == null) return null;
    return cityFromJson(cityData);
  }
}
