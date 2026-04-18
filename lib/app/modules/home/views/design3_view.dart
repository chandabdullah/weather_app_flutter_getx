import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/constants/app_constants.dart';
import '/app/models/weather_model.dart';
import '/app/modules/home/controllers/home_controller.dart';
import '/app/routes/app_pages.dart';

import '/utils/utils.dart';
import '/utils/weather_utils.dart';
import '/utils/calculation.dart';
import '/utils/datetime_utils.dart';
import '/utils/uv_calculator.dart';

class Design3View extends StatelessWidget {
  final HomeController controller;

  const Design3View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.getLocationData();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              CurrentWeatherPremium(controller: controller),
              const Gap(18),
              HourlyForecastPremium(controller: controller),
              const Gap(18),
              DailyForecastPremium(controller: controller),
              const Gap(18),
              WeatherStatsGrid(controller: controller),
              const Gap(18),
              SunriseSunsetPremium(controller: controller),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}

/// =====================================================
/// PREMIUM GLASS CARD
/// =====================================================

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withSafeOpacity(.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withSafeOpacity(.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withSafeOpacity(.08),
                blurRadius: 25,
                offset: const Offset(0, 12),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// =====================================================
/// HERO SECTION
/// =====================================================

class CurrentWeatherPremium extends StatelessWidget {
  final HomeController controller;

  const CurrentWeatherPremium({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final weather = controller.currentWeather;

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.LOCATIONS),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      const Gap(8),
                      Text(
                        controller.currentCity ?? "Unknown",
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(Routes.DESIGNS),
                icon: const Icon(Icons.tune, color: Colors.white),
              ),
            ],
          ),
          const Gap(18),
          Text(
            "${weather?.temp?.toStringAsFixed(0) ?? "--"}°",
            style: const TextStyle(
              fontSize: 74,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
            ),
          ),
          const Gap(8),
          Text(
            descriptionValues.reverseMap[weather?.weather?.first.description]
                    ?.capitalize ??
                "",
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const Gap(8),
          Text(
            DateFormat("EEEE, MMM dd").format(DateTime.now()),
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white60,
            ),
          ),
          const Gap(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniChip(
                title: "Feels",
                value: "${weather?.feelsLike?.toStringAsFixed(0)}°",
              ),
              _MiniChip(
                title: "Humidity",
                value: "${weather?.humidity ?? 0}%",
              ),
              _MiniChip(
                title: "Wind",
                value: "${convertMsToKmh(weather?.windSpeed ?? 0)} km/h",
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String title;
  final String value;

  const _MiniChip({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// =====================================================
/// HOURLY
/// =====================================================

class HourlyForecastPremium extends StatelessWidget {
  final HomeController controller;

  const HourlyForecastPremium({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Hourly Forecast"),
          const Gap(15),
          SizedBox(
            height: 118,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.hourlyForecast.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (_, index) {
                final item = controller.hourlyForecast[index];

                return Container(
                  width: 72,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withSafeOpacity(.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat("ha").format(
                          item.dt?.fromTimeStampToDateTime() ?? DateTime.now(),
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        WeatherUtils.getWeatherSvg(
                          item.weather?.first.description,
                          date: item.dt,
                          sunrise: controller.currentWeather?.sunrise,
                          sunset: controller.currentWeather?.sunset,
                        ),
                        height: 28,
                      ),
                      const Spacer(),
                      Text(
                        "${item.temp?.toStringAsFixed(0)}°",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================
/// DAILY
/// =====================================================

class DailyForecastPremium extends StatelessWidget {
  final HomeController controller;

  const DailyForecastPremium({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _sectionTitle("7-Day Forecast"),
          const Gap(12),
          ListView.separated(
            itemCount: controller.dailyForecast.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => Divider(
              color: Colors.white.withSafeOpacity(.08),
            ),
            itemBuilder: (_, index) {
              final day = controller.dailyForecast[index];

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      DateTimeUtils.getDayOrDate(
                        day.dt?.fromTimeStampToDateTime() ?? DateTime.now(),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    WeatherUtils.getWeatherSvg(
                      day.weather?.first.description,
                    ),
                    height: 28,
                  ),
                  const Gap(12),
                  Text(
                    "${day.temp?.max?.toStringAsFixed(0)}° / ${day.temp?.min?.toStringAsFixed(0)}°",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// =====================================================
/// STATS GRID
/// =====================================================

class WeatherStatsGrid extends StatelessWidget {
  final HomeController controller;

  const WeatherStatsGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final weather = controller.currentWeather;

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.45,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      children: [
        _StatCard("UV Index", UVCalculator.getUVCalculator(weather?.uvi ?? 0)),
        _StatCard("Visibility",
            "${((weather?.visibility ?? 0) / 1000).toStringAsFixed(1)} km"),
        _StatCard("Pressure", "${weather?.pressure ?? 0} hPa"),
        _StatCard(
          "Wind",
          "${convertMsToKmh(weather?.windSpeed ?? 0)} km/h",
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          const Gap(8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================
/// SUNRISE / SUNSET
/// =====================================================

class SunriseSunsetPremium extends StatelessWidget {
  final HomeController controller;

  const SunriseSunsetPremium({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final weather = controller.currentWeather;

    return Row(
      children: [
        Expanded(
          child: _SunCard(
            title: "Sunrise",
            value: DateFormat("hh:mm a").format(
              weather?.sunrise?.fromTimeStampToDateTime() ?? DateTime.now(),
            ),
          ),
        ),
        const Gap(14),
        Expanded(
          child: _SunCard(
            title: "Sunset",
            value: DateFormat("hh:mm a").format(
              weather?.sunset?.fromTimeStampToDateTime() ?? DateTime.now(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SunCard extends StatelessWidget {
  final String title;
  final String value;

  const _SunCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
            ),
          ),
          const Gap(8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

/// =====================================================
/// SECTION TITLE
/// =====================================================

Widget _sectionTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );
}
