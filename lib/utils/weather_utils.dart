import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
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
    bool isNight =
        DateTimeUtils.isNight(date: date, sunrise: sunrise, sunset: sunset);

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

  static String getWeatherSvg(
    Description? value, {
    int? date,
    int? sunrise,
    int? sunset,
  }) {
    bool isNight =
        DateTimeUtils.isNight(date: date, sunrise: sunrise, sunset: sunset);

    switch (value) {
      case Description.BROKEN_CLOUDS:
        return isNight
            ? 'assets/svg/static/cloudy-night-3.svg'
            : 'assets/svg/static/cloudy-day-3.svg';
      case Description.CLEAR_SKY:
        return isNight
            ? 'assets/svg/static/night.svg'
            : 'assets/svg/static/day.svg';
      case Description.FEW_CLOUDS:
        return isNight
            ? 'assets/svg/static/cloudy-night-1.svg'
            : 'assets/svg/static/cloudy-day-1.svg';
      case Description.LIGHT_RAIN:
        return isNight
            ? 'assets/svg/static/rainy-1.svg'
            : 'assets/svg/static/rainy-1.svg';
      case Description.MODERATE_RAIN:
        return isNight
            ? 'assets/svg/static/rainy-2.svg'
            : 'assets/svg/static/rainy-2.svg';
      case Description.OVERCAST_CLOUDS:
        return isNight
            ? 'assets/svg/static/rainy-3.svg'
            : 'assets/svg/static/rainy-3.svg';
      case Description.SCATTERED_CLOUDS:
        return isNight
            ? 'assets/svg/static/cloudy-night-2.svg'
            : 'assets/svg/static/cloudy-day-2.svg';
      default:
        return isNight
            ? 'assets/svg/static/night.svg'
            : 'assets/svg/static/day.svg';
    }
  }

  static WeatherType getWeatherTypeBg(
    Description? description, {
    int? date,
    int? sunrise,
    int? sunset,
  }) {
    bool isNight =
        DateTimeUtils.isNight(date: date, sunrise: sunrise, sunset: sunset);

    switch (description) {
      case Description.BROKEN_CLOUDS:
        return isNight ? WeatherType.cloudyNight : WeatherType.cloudy;
      case Description.CLEAR_SKY:
        return isNight ? WeatherType.sunnyNight : WeatherType.sunny;
      case Description.FEW_CLOUDS:
        return isNight ? WeatherType.cloudyNight : WeatherType.cloudy;
      case Description.LIGHT_RAIN:
        return isNight ? WeatherType.lightRainy : WeatherType.lightRainy;
      case Description.MODERATE_RAIN:
        return isNight ? WeatherType.middleRainy : WeatherType.middleRainy;
      case Description.OVERCAST_CLOUDS:
        return isNight ? WeatherType.overcast : WeatherType.overcast;
      case Description.SCATTERED_CLOUDS:
        return isNight ? WeatherType.cloudyNight : WeatherType.cloudyNight;
      default:
        return isNight ? WeatherType.sunnyNight : WeatherType.sunny;
    }
  }
}
