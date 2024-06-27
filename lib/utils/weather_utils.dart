import 'package:flutter/material.dart';
import 'package:weather_app/app/models/weather_model.dart';
import 'package:weather_app/utils/datetime_utils.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherUtils {
  static IconData getWeatherIcon(
    Description? value, {
    int? date,
    int? sunrise,
    int? sunset,
  }) {
    bool isNight = false;

    if (date != null && sunrise != null && sunset != null) {
      DateTime dateTime = date.fromTimeStampToDateTime();
      DateTime sunriseTime = sunrise.fromTimeStampToDateTime();
      DateTime sunsetTime = sunset.fromTimeStampToDateTime();

      isNight = dateTime.isBefore(sunriseTime) || dateTime.isAfter(sunsetTime);
    }

    switch (value) {
      case Description.BROKEN_CLOUDS:
        return isNight
            ? WeatherIcons.night_alt_cloudy_gusts
            : WeatherIcons.cloudy_gusts;
      case Description.CLEAR_SKY:
        return isNight ? WeatherIcons.night_clear : WeatherIcons.day_sunny;
      case Description.FEW_CLOUDS:
        return isNight ? WeatherIcons.night_cloudy : WeatherIcons.day_cloudy;
      case Description.LIGHT_RAIN:
        return isNight
            ? WeatherIcons.night_alt_lightning
            : WeatherIcons.day_lightning;
      case Description.MODERATE_RAIN:
        return isNight ? WeatherIcons.night_alt_rain : WeatherIcons.day_rain;
      case Description.OVERCAST_CLOUDS:
        return isNight
            ? WeatherIcons.night_alt_cloudy
            : WeatherIcons.day_cloudy;
      case Description.SCATTERED_CLOUDS:
        return isNight
            ? WeatherIcons.night_alt_cloudy_windy
            : WeatherIcons.day_cloudy_windy;
      default:
        return isNight ? WeatherIcons.night_clear : WeatherIcons.day_sunny;
    }
  }
}
