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

  static String getWindDirection(int degrees, {bool fullName = false}) {
    if (degrees < 0 || degrees > 360) {
      return 'Invalid';
    }

    const List<String> shortDirections = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
      'N'
    ];

    const List<String> fullDirections = [
      'North',
      'North-Northeast',
      'Northeast',
      'East-Northeast',
      'East',
      'East-Southeast',
      'Southeast',
      'South-Southeast',
      'South',
      'South-Southwest',
      'Southwest',
      'West-Southwest',
      'West',
      'West-Northwest',
      'Northwest',
      'North-Northwest',
      'North'
    ];

    int index = ((degrees + 11.25) / 22.5).floor() % 16;
    return fullName ? fullDirections[index] : shortDirections[index];
  }

  static IconData getWindDirectionIcon(int degrees) {
    String direction = getWindDirection(degrees);

    switch (direction) {
      case 'N':
      case 'North':
        return Icons.arrow_upward;
      case 'NNE':
      case 'North-Northeast':
      case 'NE':
      case 'Northeast':
        return Icons.arrow_upward;
      case 'ENE':
      case 'East-Northeast':
      case 'E':
      case 'East':
        return Icons.arrow_forward;
      case 'ESE':
      case 'East-Southeast':
      case 'SE':
      case 'Southeast':
        return Icons.arrow_forward;
      case 'SSE':
      case 'South-Southeast':
      case 'S':
      case 'South':
        return Icons.arrow_downward;
      case 'SSW':
      case 'South-Southwest':
      case 'SW':
      case 'Southwest':
        return Icons.arrow_downward;
      case 'WSW':
      case 'West-Southwest':
      case 'W':
      case 'West':
        return Icons.arrow_back;
      case 'WNW':
      case 'West-Northwest':
      case 'NW':
      case 'Northwest':
        return Icons.arrow_back;
      case 'NNW':
      case 'North-Northwest':
        return Icons.arrow_upward;
      default:
        return Icons.help;
    }
  }
}
