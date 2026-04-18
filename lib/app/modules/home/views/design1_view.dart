import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/app/widgets/blur_container.dart';
import 'package:weather_app/config/theme/my_gradient.dart';
import '../../../../utils/utils.dart';
import '/app/components/my_widgets_animator.dart';
import '/app/constants/app_constants.dart';
import '/app/models/weather_model.dart';
import '/app/modules/home/controllers/home_controller.dart';
import '/app/routes/app_pages.dart';
import '/app/services/api_call_status.dart';
import '/utils/calculation.dart';
import '/utils/datetime_utils.dart';
import '/utils/uv_calculator.dart';
import '/utils/weather_utils.dart';
import 'package:weather_icons/weather_icons.dart';

class Design1View extends GetView {
  const Design1View({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WeatherBg(
            width: Get.width,
            height: Get.height,
            weatherType: WeatherUtils.getWeatherTypeBg(
              controller.currentWeather?.weather?.first.description,
              rain: controller.currentWeather?.rain,
              snow: controller.currentWeather?.snow,
              date: controller.currentWeather?.dt,
              sunrise: controller.currentWeather?.sunrise,
              sunset: controller.currentWeather?.sunset,
            ),
          ),
          BlurContainer(
            color: MyGradient.getAppBarColor(
              controller.currentWeather?.weather?.first.description,
            ).withSafeOpacity(.3),
            filter: ImageFilter.blur(),
            child: SizedBox(
              child: SafeArea(
                child: controller.isLoadingLocation
                    ? SizedBox(
                        width: Get.width,
                        height: Get.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const Gap(kSpacing),
                            Text(
                              "Getting info...",
                              style: Get.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : !controller.isLocationEnabled
                        ? Container(
                            padding: const EdgeInsets.all(kPadding * 3),
                            height: Get.height,
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_off_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                const Gap(20),
                                Text(
                                  "Location Disabled",
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  "Enable location permission to get weather detail for your area",
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const Gap(20),
                                TextButton(
                                  style: ButtonStyle(
                                    elevation: WidgetStateProperty.all(0),
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.white.withSafeOpacity(.2),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                      Get.theme.primaryColor,
                                    ),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: kPadding,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.getLocationData();
                                  },
                                  child: Text(
                                    "Enable Now",
                                    style: Get.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            child: MyWidgetsAnimator(
                              apiCallStatus: controller.apiCallStatus,
                              loadingWidget: () => const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                              successWidget: () =>
                                  SuccessBody(controller: controller),
                            ),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessBody extends StatelessWidget {
  const SuccessBody({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        children: [
          CurrentWeather(controller: controller),
          const Gap(kSpacing),
          Column(
            children: [
              HourlyForecast(controller: controller),
              const Gap(kSpacing),
              DailyForecast(controller: controller),
              const Gap(kSpacing),
              WeatherDetails(controller: controller),
              SunsetSunrise(controller: controller),
            ],
          )
        ],
      ),
    );
  }
}

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.cardColor.withSafeOpacity(.3),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      const Gap(10),
                      Text(
                        controller.currentCity ?? "",
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      //   size: 25,
                      // ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.SETTINGS);
                },
                color: Colors.white,
                icon: const Icon(Icons.palette_outlined),
              ),
            ],
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: kPadding,
                ),
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.apiCallStatus == ApiCallStatus.success
                              ? "${controller.currentWeather?.temp?.toStringAsFixed(0)}"
                              : "__",
                          style: Get.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 70,
                            fontFamily: temperatureFont,
                          ),
                        ),
                        const Icon(
                          WeatherIcons.celsius,
                          size: 40,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    if (controller.currentWeather?.weather?.first.description !=
                        null)
                      Icon(
                        WeatherUtils.getWeatherIcon(
                          controller.currentWeather?.weather?.first.description,
                          date: controller.currentWeather?.dt,
                          sunrise: controller.currentWeather?.sunrise,
                          sunset: controller.currentWeather?.sunset,
                        ),
                        size: 50,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
              const Spacer(),
              if (controller.apiCallStatus == ApiCallStatus.success)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat(DateFormat.ABBR_MONTH_DAY).format(
                        controller.currentWeather?.dt
                                ?.fromTimeStampToDateTime() ??
                            DateTime.now(),
                      ),
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Gap(4),
                    if (controller.currentWeather?.weather?.first.main != null)
                      Text(
                        descriptionValues.reverseMap[controller
                                    .currentWeather?.weather?.first.description]
                                .toString()
                                .capitalize ??
                            "",
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    RichText(
                      text: TextSpan(
                        text: "Feel like ",
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "${controller.currentWeather?.feelsLike?.toStringAsFixed(0)}ºC",
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontFamily: temperatureFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                  ],
                ),
              const Gap(kSpacing),
            ],
          ),
        ],
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.cardColor.withSafeOpacity(.3),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kSpacing,
              vertical: kSpacing / 2,
            ),
            child: Text(
              "Hourly Forecast",
              style: Get.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 130,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var hourly in controller.hourlyForecast)
                    SizedBox(
                      height: 130,
                      width: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Gap(10),
                          Text(
                            DateFormat(DateFormat.HOUR_MINUTE).format(
                              hourly.dt?.fromTimeStampToDateTime() ??
                                  DateTime.now(),
                            ),
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          SvgPicture.asset(
                            WeatherUtils.getWeatherSvg(
                              hourly.weather?.first.description,
                              date: hourly.dt,
                              sunrise: controller.currentWeather?.sunrise,
                              sunset: controller.currentWeather?.sunset,
                            ),
                          ),
                          Text(
                            "${hourly.temp?.toStringAsFixed(0) ?? 0}ºC",
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: temperatureFont,
                            ),
                          ),
                          Text(
                            ((hourly.clouds ?? 0) > 50 &&
                                    (hourly.weather?.first.main == Main.CLOUDS))
                                ? "${hourly.clouds}%"
                                : "",
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: temperatureFont,
                              fontSize: 10,
                            ),
                          ),
                          const Gap(4),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyForecast extends StatelessWidget {
  const DailyForecast({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.cardColor.withSafeOpacity(.3),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Daily Forecast",
            style: Get.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListView.separated(
            itemCount: controller.dailyForecast.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.white,
                height: 25,
                thickness: .5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              Daily daily = controller.dailyForecast[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateTimeUtils.getDayOrDate(
                            daily.dt?.fromTimeStampToDateTime() ??
                                DateTime.now(),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        mainValues.reverseMap[daily.weather?.first.main]
                                .toString()
                                .capitalize ??
                            "",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: "Humidity: ",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "${daily.humidity}%",
                                              style: Get.textTheme.bodyLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            )
                                          ]),
                                    ),
                                    const Gap(8),
                                    RichText(
                                      text: TextSpan(
                                          text: "Wind: ",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${convertMsToKmh(daily.windSpeed ?? 0)} km/h ",
                                              style: Get.textTheme.bodyLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(kSpacing),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          WeatherIcons.cloudy,
                                          size: 17,
                                          color: Colors.white,
                                        ),
                                        const Gap(8),
                                        Text(
                                          "${daily.clouds}%",
                                          style:
                                              Get.textTheme.bodyLarge?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          WeatherIcons.thermometer,
                                          size: 17,
                                          color: Colors.white,
                                        ),
                                        const Gap(4),
                                        Text(
                                          "${daily.temp?.max?.toStringAsFixed(0) ?? 0}º"
                                          "/"
                                          "${daily.temp?.min?.toStringAsFixed(0) ?? 0}º",
                                          style:
                                              Get.textTheme.bodyLarge?.copyWith(
                                            fontFamily: temperatureFont,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                      const Gap(kPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            WeatherUtils.getWeatherSvg(
                              daily.weather?.first.description,
                            ),
                            height: 70,
                          ),
                        ],
                      ),
                    ],
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

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentWeather?.humidity != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        WeatherIcons.humidity,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "Humidity",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${controller.currentWeather?.humidity ?? 0}%",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.currentWeather?.humidity != null)
              const Gap(kSpacing),
            if (controller.currentWeather?.windSpeed != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        WeatherIcons.thermometer,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "UV",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        UVCalculator.getUVCalculator(
                          controller.currentWeather?.uvi ?? 0,
                        ),
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.currentWeather?.windSpeed != null)
              const Gap(kSpacing),
            if (controller.currentWeather?.visibility != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "Visibility",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${((controller.currentWeather?.visibility ?? 0) / 1000).toStringAsFixed(0)} km",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if ((controller.currentWeather?.humidity != null) ||
            (controller.currentWeather?.windSpeed != null) ||
            (controller.currentWeather?.visibility != null))
          const Gap(kSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentWeather?.uvi != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        WeatherIcons.windy,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "Wind",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${WeatherUtils.getWindDirection(controller.currentWeather?.windDeg ?? 0)} "
                        "${convertMsToKmh(controller.currentWeather?.windSpeed ?? 0)} km/h",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.currentWeather?.uvi != null) const Gap(kSpacing),
            if (controller.currentWeather?.pressure != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        WeatherIcons.barometer,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "Pressure",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${controller.currentWeather?.pressure ?? 0} hPa",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if ((controller.currentWeather?.uvi != null) ||
            (controller.currentWeather?.pressure != null))
          const Gap(kSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentWeather?.rain?.the1H != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        WeatherIcons.rain,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "Rain",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${controller.currentWeather?.rain?.the1H ?? 0} mm/h",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.currentWeather?.rain?.the1H != null)
              const Gap(kSpacing),
            if (controller.currentWeather?.snow?.the1H != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withSafeOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        WeatherIcons.snow,
                        size: 30,
                        color: Get.theme.cardColor,
                      ),
                      const Gap(8),
                      Text(
                        "Snow",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${controller.currentWeather?.snow?.the1H ?? 0} mm/h",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if ((controller.currentWeather?.rain?.the1H != null) ||
            (controller.currentWeather?.snow?.the1H != null))
          const Gap(kSpacing),
      ],
    );
  }
}

class SunsetSunrise extends StatelessWidget {
  const SunsetSunrise({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (controller.currentWeather?.uvi != null)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(kSpacing),
              decoration: BoxDecoration(
                color: Get.theme.cardColor.withSafeOpacity(.3),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  Icon(
                    WeatherIcons.sunrise,
                    size: 30,
                    color: Get.theme.cardColor,
                  ),
                  const Gap(8),
                  Text(
                    "Sunrise",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    DateFormat(DateFormat.HOUR_MINUTE).format(
                      controller.currentWeather?.sunrise
                              ?.fromTimeStampToDateTime() ??
                          DateTime.now(),
                    ),
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Gap(kSpacing),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(kSpacing),
            decoration: BoxDecoration(
              color: Get.theme.cardColor.withSafeOpacity(.3),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                Icon(
                  WeatherIcons.sunset,
                  size: 30,
                  color: Get.theme.cardColor,
                ),
                const Gap(8),
                Text(
                  "Sunset",
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateFormat(DateFormat.HOUR_MINUTE).format(
                    controller.currentWeather?.sunset
                            ?.fromTimeStampToDateTime() ??
                        DateTime.now(),
                  ),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
