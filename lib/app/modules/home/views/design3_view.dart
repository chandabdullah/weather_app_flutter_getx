import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../../utils/utils.dart';
import '/app/components/my_widgets_animator.dart';
import '/app/constants/app_constants.dart';
import '/app/models/weather_model.dart';
import '/app/modules/home/controllers/home_controller.dart';
import '/app/routes/app_pages.dart';
import '/utils/calculation.dart';
import '/utils/datetime_utils.dart';
import '/utils/uv_calculator.dart';
import '/utils/weather_utils.dart';

class Design3View extends StatelessWidget {
  const Design3View({
    super.key,
    required this.controller,
  });

  @override
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final current = controller.currentWeather;
    final weatherType = WeatherUtils.getWeatherTypeBg(
      current?.weather?.first.description,
      rain: current?.rain,
      snow: current?.snow,
      date: current?.dt,
      sunrise: current?.sunrise,
      sunset: current?.sunset,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: WeatherBg(
              width: Get.width,
              height: Get.height,
              weatherType: weatherType,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _overlayColors(current),
                ),
              ),
            ),
          ),
          const Positioned(
            top: -80,
            right: -60,
            child: _AtmosphericGlow(
              size: 220,
              color: Color(0x33FFFFFF),
            ),
          ),
          Positioned(
            top: Get.height * 0.30,
            left: -70,
            child: const _AtmosphericGlow(
              size: 190,
              color: Color(0x26AEE8FF),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -40,
            child: _AtmosphericGlow(
              size: 180,
              color: Colors.white.withSafeOpacity(.12),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Builder(
              builder: (context) {
                if (controller.isLoadingLocation) {
                  return const _CenteredState(
                    child: _LoadingCard(
                      title: "Getting info...",
                      subtitle: "Looking up your live location and forecast.",
                    ),
                  );
                }

                if (!controller.isLocationEnabled) {
                  return _CenteredState(
                    child: _ActionCard(
                      icon: Icons.location_off_rounded,
                      title: "Location Disabled",
                      subtitle:
                          "Enable location permission to get the latest weather for your area.",
                      buttonText: "Enable Now",
                      onTap: controller.getLocationData,
                    ),
                  );
                }

                return _Content(controller: controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.getWeatherData(true),
      color: Colors.white,
      backgroundColor: Colors.black.withSafeOpacity(.3),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          kPadding,
          kPadding,
          kPadding,
          kPadding * 2,
        ),
        child: MyWidgetsAnimator(
          apiCallStatus: controller.apiCallStatus,
          loadingWidget: () => const Padding(
            padding: EdgeInsets.only(top: 120),
            child: _LoadingCard(
              title: "Updating forecast",
              subtitle: "Pulling in the freshest conditions for your location.",
            ),
          ),
          successWidget: () => _SuccessBody(controller: controller),
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroWeatherCard(controller: controller),
        const Gap(18),
        const _SectionLabel(
          icon: WeatherIcons.day_sunny,
          title: "Today at a glance",
        ),
        const Gap(10),
        _HighlightsGrid(controller: controller),
        const Gap(18),
        const _SectionLabel(
          icon: WeatherIcons.time_3,
          title: "Hourly rhythm",
        ),
        const Gap(10),
        _HourlyForecastStrip(controller: controller),
        const Gap(18),
        const _SectionLabel(
          icon: WeatherIcons.horizon_alt,
          title: "Sun schedule",
        ),
        const Gap(10),
        _SunCycleCard(controller: controller),
        const Gap(18),
        const _SectionLabel(
          icon: WeatherIcons.raindrops,
          title: "Next 7 days",
        ),
        const Gap(10),
        _DailyForecastCard(controller: controller),
      ],
    );
  }
}

class _HeroWeatherCard extends StatelessWidget {
  const _HeroWeatherCard({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final current = controller.currentWeather;
    final today = controller.dailyForecast.isNotEmpty
        ? controller.dailyForecast.first
        : null;
    final description = descriptionValues
            .reverseMap[current?.weather?.first.description]?.capitalize ??
        "Live forecast";
    final accent = _accentColor(current);

    return _GlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withSafeOpacity(.14),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withSafeOpacity(.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.currentCity ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            DateFormat('EEEE, d MMM').format(DateTime.now()),
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withSafeOpacity(.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              _CircleIconButton(
                icon: Icons.palette_outlined,
                onTap: () => Get.toNamed(Routes.SETTINGS),
              ),
            ],
          ),
          const Gap(22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _HeroBadge(
                          label: description,
                          accent: accent,
                        ),
                        _HeroBadge(
                          label:
                              "Feels like ${_temp(controller.currentWeather?.feelsLike)}",
                          accent: Colors.white.withSafeOpacity(.18),
                        ),
                      ],
                    ),
                    const Gap(18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            current?.temp?.toStringAsFixed(0) ?? "--",
                            style: Get.textTheme.displayLarge?.copyWith(
                              fontSize: 92,
                              height: .95,
                              fontWeight: FontWeight.w700,
                              fontFamily: temperatureFont,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "°C",
                            style: Get.textTheme.headlineMedium?.copyWith(
                              color: Colors.white.withSafeOpacity(.92),
                              fontWeight: FontWeight.w600,
                              fontFamily: temperatureFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _heroSummary(current, today),
                      style: Get.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withSafeOpacity(.82),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: .94, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withSafeOpacity(.10),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withSafeOpacity(.18),
                          ),
                        ),
                        child: SvgPicture.asset(
                          WeatherUtils.getWeatherSvg(
                            current?.weather?.first.description,
                            date: current?.dt,
                            sunrise: current?.sunrise,
                            sunset: current?.sunset,
                          ),
                          height: 118,
                        ),
                      ),
                    ),
                    const Gap(14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _MiniMetric(
                          label: "High",
                          value: _temp(today?.temp?.max),
                        ),
                        const Gap(10),
                        _MiniMetric(
                          label: "Low",
                          value: _temp(today?.temp?.min),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighlightsGrid extends StatelessWidget {
  const _HighlightsGrid({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final current = controller.currentWeather;
    final cards = <_WeatherMetricData>[
      _WeatherMetricData(
        icon: WeatherIcons.humidity,
        label: "Humidity",
        value: "${current?.humidity ?? 0}%",
        hint: "Moisture in the air",
      ),
      _WeatherMetricData(
        icon: WeatherIcons.strong_wind,
        label: "Wind",
        value:
            "${WeatherUtils.getWindDirection(current?.windDeg ?? 0)} ${convertMsToKmh(current?.windSpeed ?? 0)} km/h",
        hint: "Direction and speed",
      ),
      _WeatherMetricData(
        icon: WeatherIcons.day_sunny,
        label: "UV Index",
        value: UVCalculator.getUVCalculator(current?.uvi ?? 0),
        hint: "Level ${current?.uvi?.toStringAsFixed(1) ?? '0.0'}",
      ),
      _WeatherMetricData(
        icon: WeatherIcons.fog,
        label: "Visibility",
        value: "${((current?.visibility ?? 0) / 1000).toStringAsFixed(1)} km",
        hint: "Road clarity",
      ),
      _WeatherMetricData(
        icon: WeatherIcons.barometer,
        label: "Pressure",
        value: "${current?.pressure ?? 0} hPa",
        hint: "Atmospheric pressure",
      ),
      _WeatherMetricData(
        icon: WeatherIcons.raindrops,
        label: "Precipitation",
        value: _precipitationText(current),
        hint: "Current hourly rate",
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];
        return _GlassPanel(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withSafeOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  card.icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const Spacer(),
              Text(
                card.label,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withSafeOpacity(.72),
                ),
              ),
              const Gap(6),
              Text(
                card.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(4),
              Text(
                card.hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withSafeOpacity(.56),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HourlyForecastStrip extends StatelessWidget {
  const _HourlyForecastStrip({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final hours = controller.hourlyForecast.take(12).toList();

    return SizedBox(
      height: 172,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hours.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, index) {
          final hourly = hours[index];
          final isNow = index == 0;
          final rainChance = ((hourly.pop ?? 0) * 100).round();

          return _GlassPanel(
            width: 110,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isNow
                      ? "Now"
                      : DateFormat('ha').format(
                          hourly.dt?.fromTimeStampToDateTime() ??
                              DateTime.now(),
                        ),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(10),
                SvgPicture.asset(
                  WeatherUtils.getWeatherSvg(
                    hourly.weather?.first.description,
                    date: hourly.dt,
                    sunrise: controller.currentWeather?.sunrise,
                    sunset: controller.currentWeather?.sunset,
                  ),
                  height: 42,
                ),
                const Spacer(),
                Text(
                  _temp(hourly.temp),
                  style: Get.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: temperatureFont,
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withSafeOpacity(.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "$rainChance% rain",
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withSafeOpacity(.74),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SunCycleCard extends StatelessWidget {
  const _SunCycleCard({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final sunrise =
        controller.currentWeather?.sunrise?.fromTimeStampToDateTime();
    final sunset = controller.currentWeather?.sunset?.fromTimeStampToDateTime();
    final daylightDuration =
        sunrise != null && sunset != null ? sunset.difference(sunrise) : null;

    return _GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SunMetric(
                  icon: WeatherIcons.sunrise,
                  label: "Sunrise",
                  value: sunrise == null
                      ? "--"
                      : DateFormat('h:mm a').format(sunrise),
                ),
              ),
              Container(
                width: 1,
                height: 56,
                color: Colors.white.withSafeOpacity(.12),
              ),
              Expanded(
                child: _SunMetric(
                  icon: WeatherIcons.sunset,
                  label: "Sunset",
                  value: sunset == null
                      ? "--"
                      : DateFormat('h:mm a').format(sunset),
                ),
              ),
            ],
          ),
          const Gap(16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: _dayProgress(
                controller.currentWeather?.dt,
                controller.currentWeather?.sunrise,
                controller.currentWeather?.sunset,
              ),
              backgroundColor: Colors.white.withSafeOpacity(.10),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFD36A),
              ),
            ),
          ),
          const Gap(12),
          Text(
            daylightDuration == null
                ? "Sun timing unavailable"
                : "Daylight lasts ${_formatDuration(daylightDuration)} today",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withSafeOpacity(.76),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyForecastCard extends StatelessWidget {
  const _DailyForecastCard({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: List.generate(controller.dailyForecast.length, (index) {
          final daily = controller.dailyForecast[index];
          final rainChance = ((daily.pop ?? 0) * 100).round();

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == controller.dailyForecast.length - 1 ? 0 : 14,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 66,
                      child: Text(
                        index == 0
                            ? "Today"
                            : DateFormat('EEE').format(
                                daily.dt?.fromTimeStampToDateTime() ??
                                    DateTime.now(),
                              ),
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Gap(6),
                    SvgPicture.asset(
                      WeatherUtils.getWeatherSvg(
                        daily.weather?.first.description,
                        date: daily.dt,
                        sunrise: daily.sunrise,
                        sunset: daily.sunset,
                      ),
                      height: 34,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainValues.reverseMap[daily.weather?.first.main]
                                    ?.capitalize ??
                                "Forecast",
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(3),
                          Text(
                            rainChance > 0
                                ? "$rainChance% chance of rain"
                                : "Stable conditions",
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withSafeOpacity(.62),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${daily.temp?.max?.toStringAsFixed(0) ?? '--'}°",
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: temperatureFont,
                          ),
                        ),
                        Text(
                          "${daily.temp?.min?.toStringAsFixed(0) ?? '--'}°",
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withSafeOpacity(.58),
                            fontFamily: temperatureFont,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (index != controller.dailyForecast.length - 1) ...[
                  const Gap(14),
                  Divider(
                    height: 1,
                    color: Colors.white.withSafeOpacity(.08),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withSafeOpacity(.94),
          size: 18,
        ),
        const Gap(8),
        Text(
          title,
          style: Get.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withSafeOpacity(.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withSafeOpacity(.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.white.withSafeOpacity(.60),
            ),
          ),
          const Gap(4),
          Text(
            value,
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: temperatureFont,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.label,
    required this.accent,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withSafeOpacity(.16),
        ),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SunMetric extends StatelessWidget {
  const _SunMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFFD36A),
            size: 22,
          ),
          const Gap(10),
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withSafeOpacity(.68),
            ),
          ),
          const Gap(4),
          Text(
            value,
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    this.padding,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withSafeOpacity(.10),
              border: Border.all(
                color: Colors.white.withSafeOpacity(.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withSafeOpacity(.10),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withSafeOpacity(.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withSafeOpacity(.14),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }
}

class _AtmosphericGlow extends StatelessWidget {
  const _AtmosphericGlow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _CenteredState extends StatelessWidget {
  const _CenteredState({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: child,
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 26,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          ),
          const Gap(18),
          Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withSafeOpacity(.70),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 26,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 42,
            color: Colors.white,
          ),
          const Gap(18),
          Text(
            title,
            style: Get.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withSafeOpacity(.72),
            ),
          ),
          const Gap(20),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF123B64),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

class _WeatherMetricData {
  const _WeatherMetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
  });

  final IconData icon;
  final String label;
  final String value;
  final String hint;
}

List<Color> _overlayColors(Current? current) {
  final description = current?.weather?.first.description;
  final isNight = DateTimeUtils.isNight(
    date: current?.dt,
    sunrise: current?.sunrise,
    sunset: current?.sunset,
  );

  if (description == Description.LIGHT_RAIN ||
      description == Description.MODERATE_RAIN) {
    return [
      const Color(0xCC10233F),
      const Color(0xCC1A4A6A),
      const Color(0xCC0E1828),
    ];
  }

  if (isNight) {
    return [
      const Color(0xD9101730),
      const Color(0xC9192C56),
      const Color(0xD9080F1A),
    ];
  }

  if (description == Description.CLEAR_SKY) {
    return [
      const Color(0x991A79C8),
      const Color(0xAA55B8F6),
      const Color(0xBB103B66),
    ];
  }

  return [
    const Color(0xB51C3F63),
    const Color(0xB44C7FA4),
    const Color(0xC2172742),
  ];
}

Color _accentColor(Current? current) {
  final description = current?.weather?.first.description;

  switch (description) {
    case Description.CLEAR_SKY:
      return const Color(0x33FFB84D);
    case Description.LIGHT_RAIN:
    case Description.MODERATE_RAIN:
      return const Color(0x3366D6FF);
    case Description.BROKEN_CLOUDS:
    case Description.OVERCAST_CLOUDS:
      return const Color(0x33D4E4F7);
    default:
      return Colors.white.withSafeOpacity(.14);
  }
}

String _heroSummary(Current? current, Daily? today) {
  final high = today?.temp?.max?.toStringAsFixed(0) ?? "--";
  final low = today?.temp?.min?.toStringAsFixed(0) ?? "--";
  final wind = convertMsToKmh(current?.windSpeed ?? 0);

  return "High $high° • Low $low° • Wind $wind km/h";
}

String _temp(double? value) {
  if (value == null) {
    return "--";
  }

  return "${value.toStringAsFixed(0)}°";
}

String _precipitationText(Current? current) {
  final rain = current?.rain?.the1H;
  final snow = current?.snow?.the1H;

  if (rain != null && rain > 0) {
    return "${rain.toStringAsFixed(1)} mm/h";
  }

  if (snow != null && snow > 0) {
    return "${snow.toStringAsFixed(1)} mm/h";
  }

  return "No precipitation";
}

double _dayProgress(int? date, int? sunrise, int? sunset) {
  if (date == null || sunrise == null || sunset == null) {
    return .5;
  }

  final total = math.max(1, sunset - sunrise);
  final elapsed = (date - sunrise).clamp(0, total);
  return elapsed / total;
}

String _formatDuration(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60);

  if (minutes == 0) {
    return "$hours h";
  }

  return "$hours h $minutes m";
}
