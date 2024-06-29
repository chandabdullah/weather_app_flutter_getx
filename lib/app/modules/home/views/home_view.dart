import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:weather_app/app/components/my_widgets_animator.dart';
import 'package:weather_app/app/constants/app_constants.dart';
import 'package:weather_app/app/models/weather_model.dart';
import 'package:weather_app/app/routes/app_pages.dart';
import 'package:weather_app/app/services/api_call_status.dart';
import 'package:weather_app/config/theme/my_gradient.dart';
import 'package:weather_app/utils/calculation.dart';
import 'package:weather_app/utils/uv_calculator.dart';
import 'package:weather_app/utils/weather_utils.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/datetime_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (_) {
      return Scaffold(
        // appBar: AppBar(
        //   // backgroundColor: Get.theme.primaryColor,
        //   backgroundColor: MyGradient.getAppBarColor(
        //     controller.currentWeather?.weather?.first.description,
        //     // Description.FEW_CLOUDS,
        //   ),
        //   elevation: 0,
        //   title: GestureDetector(
        //     onTap: () {
        //       Get.toNamed(Routes.LOCATIONS);
        //     },
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         const Icon(
        //           Icons.location_on,
        //           color: Colors.white,
        //         ),
        //         const Gap(10),
        //         Text(
        //           controller.currentCity ?? "",
        //           style: const TextStyle(
        //             color: Colors.white,
        //           ),
        //         ),
        //         const Icon(
        //           Icons.arrow_drop_down,
        //           color: Colors.white,
        //         ),
        //       ],
        //     ),
        //   ),
        //   centerTitle: false,
        //   actions: [
        //     // Text(
        //     //   DateFormat(DateFormat.ABBR_MONTH_DAY).format(DateTime.now()),
        //     //   style: Get.textTheme.bodyLarge?.copyWith(
        //     //     color: Colors.white,
        //     //   ),
        //     // ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.settings),
        //     ),
        //     const Gap(10),
        //   ],
        //   bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(80),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(
        //             left: kPadding,
        //           ),
        //           child: Row(
        //             children: [
        //               Row(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     controller.apiCallStatus == ApiCallStatus.success
        //                         ? "${controller.currentWeather?.temp?.toStringAsFixed(0)}"
        //                         : "__",
        //                     style: Get.textTheme.displayLarge?.copyWith(
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                   const Icon(
        //                     WeatherIcons.celsius,
        //                     size: 40,
        //                     color: Colors.white,
        //                   ),
        //                 ],
        //               ),
        //               const Gap(10),
        //               // if (controller.isLocationEnabled)
        //               if (controller
        //                       .currentWeather?.weather?.first.description !=
        //                   null)
        //                 //   Image.network(
        //                 //     'https://openweathermap.org/img/wn/${controller.currentWeather?.weather?.first.icon}@2x.png',
        //                 //     height: 100,
        //                 //     width: 100,
        //                 //   ),
        //                 // SvgPicture.asset(
        //                 //   'assets/svg/static/day.svg',
        //                 //   height: 85,
        //                 // ),
        //                 Icon(
        //                   WeatherUtils.getWeatherIcon(
        //                     controller
        //                         .currentWeather?.weather?.first.description,
        //                     date: controller.currentWeather?.dt,
        //                     sunrise: controller.currentWeather?.sunrise,
        //                     sunset: controller.currentWeather?.sunset,
        //                   ),
        //                   size: 50,
        //                   color: Colors.white,
        //                 ),
        //             ],
        //           ),
        //         ),
        //         const Spacer(),
        //         if (controller.apiCallStatus == ApiCallStatus.success)
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //               Text(
        //                 DateFormat(DateFormat.ABBR_MONTH_DAY).format(
        //                   controller.currentWeather?.dt
        //                           ?.fromTimeStampToDateTime() ??
        //                       DateTime.now(),
        //                 ),
        //                 style: Get.textTheme.titleLarge?.copyWith(
        //                   color: Colors.white,
        //                 ),
        //               ),
        //               const Gap(4),
        //               if (controller.currentWeather?.weather?.first.main !=
        //                   null)
        //                 Text(
        //                   descriptionValues.reverseMap[controller.currentWeather
        //                               ?.weather?.first.description]
        //                           .toString()
        //                           .capitalize ??
        //                       "",
        //                   style: Get.textTheme.titleMedium?.copyWith(
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               Text(
        //                 "Feel like ${controller.currentWeather?.feelsLike?.toStringAsFixed(0)}ºC",
        //                 style: Get.textTheme.titleMedium?.copyWith(
        //                   color: Colors.white,
        //                 ),
        //               ),
        //               const Gap(5),
        //             ],
        //           ),
        //         const Gap(kSpacing),
        //       ],
        //     ),
        //   ),
        // ),

        // body: SafeArea(
        //   child: Padding(
        //     padding: const EdgeInsets.all(kPadding),
        //     child: Column(
        //       children: [
        //         Stack(
        //           children: [
        //             WeatherBg(
        //               width: Get.width,
        //               height: 150,
        //               weatherType: WeatherUtils.getWeatherTypeBg(
        //                 controller.currentWeather?.weather?.first.description,
        //                 // Description.BROKEN_CLOUDS,
        //                 date: controller.currentWeather?.dt,
        //                 sunrise: controller.currentWeather?.sunrise,
        //                 sunset: controller.currentWeather?.sunset,
        //               ),
        //             ),
        //             BackdropFilter(
        //               filter: ImageFilter.blur(
        //                 sigmaX: 5,
        //                 sigmaY: 5,
        //                 tileMode: TileMode.mirror,
        //               ),
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   color: Colors.black.withOpacity(.3),
        //                   borderRadius: BorderRadius.circular(kBorderRadius),
        //                 ),
        //                 child: CurrentWeather(controller: controller),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        body: Stack(
          children: [
            WeatherBg(
              width: Get.width,
              height: Get.height,
              weatherType: WeatherUtils.getWeatherTypeBg(
                controller.currentWeather?.weather?.first.description,
                // Description.BROKEN_CLOUDS,
                date: controller.currentWeather?.dt,
                sunrise: controller.currentWeather?.sunrise,
                sunset: controller.currentWeather?.sunset,
              ),
            ),
            BlurContainer(
              controller: controller,
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
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
                    : SmartRefresher(
                        controller: controller.smartRefreshController,
                        onRefresh: () async {
                          await controller.getWeatherInfo();
                          controller.smartRefreshController.refreshCompleted();
                        },
                        child: MyWidgetsAnimator(
                          apiCallStatus: controller.apiCallStatus,
                          loadingWidget: () => const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                          successWidget: () => SingleChildScrollView(
                            padding: const EdgeInsets.all(kPadding),
                            child: Column(
                              children: [
                                // * Current Weather
                                CurrentWeather(controller: controller),
                                const Gap(kSpacing),

                                Column(
                                  children: [
                                    // * Hourly Forecast
                                    HourlyForecast(controller: controller),
                                    const Gap(kSpacing),

                                    // * Daily Forecast
                                    DailyForecast(controller: controller),
                                    const Gap(kSpacing),

                                    // * Weather Details
                                    WeatherDetails(controller: controller),

                                    // * Sunrise, Sunset
                                    SunsetSunrise(controller: controller),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    required this.controller,
    required this.child,
    required this.filter,
  });

  final HomeController controller;
  final Widget child;
  final ImageFilter filter;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: filter,
      child: Container(
        decoration: BoxDecoration(
          color: MyGradient.getAppBarColor(
            controller.currentWeather?.weather?.first.description,
          ).withOpacity(.3),
        ),
        child: child,
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
      // margin: const EdgeInsets.only(
      //   // top: 150,
      //   bottom: kPadding,
      // ),
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.cardColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.LOCATIONS);
                  },
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
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              IconButton(
                onPressed: () {},
                color: Colors.white,
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
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
                    const Gap(10),
                    // if (controller.isLocationEnabled)
                    if (controller.currentWeather?.weather?.first.description !=
                        null)
                      //   Image.network(
                      //     'https://openweathermap.org/img/wn/${controller.currentWeather?.weather?.first.icon}@2x.png',
                      //     height: 100,
                      //     width: 100,
                      //   ),
                      // SvgPicture.asset(
                      //   'assets/svg/static/day.svg',
                      //   height: 85,
                      // ),
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
        color: Get.theme.cardColor.withOpacity(.3),
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
                          // Image.network(
                          //   'https://openweathermap.org/img/wn/${hourly.weather?.first.icon}@2x.png',
                          //   height: 50,
                          //   width: 50,
                          // ),
                          FittedBox(
                            child: SvgPicture.asset(
                              WeatherUtils.getWeatherSvg(
                                hourly.weather?.first.description,
                                date: hourly.dt,
                                sunrise: controller.currentWeather?.sunrise,
                                sunset: controller.currentWeather?.sunset,
                              ),
                            ),
                          ),
                          // Icon(
                          //   WeatherUtils.getWeatherIcon(
                          //     hourly.weather?.first.description,
                          //     date: hourly.dt,
                          //     sunrise: controller.currentWeather?.sunrise,
                          //     sunset: controller.currentWeather?.sunset,
                          //   ),
                          //   color: Colors.white,
                          // ),

                          Text(
                            "${hourly.temp?.toStringAsFixed(0) ?? 0}ºC",
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: temperatureFont,
                            ),
                          ),
                          Text(
                            ((hourly.clouds ?? 0) > 75 &&
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
        color: Get.theme.cardColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "7-days Forecast",
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

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // SvgPicture.asset(
                      //   WeatherUtils.getWeatherSvg(
                      //     daily.weather?.first.description,
                      //   ),
                      //   height: 50,
                      // ),
                      Icon(
                        WeatherUtils.getWeatherIcon(
                          daily.weather?.first.description,
                        ),
                        color: Colors.white,
                        size: 25.sp,
                      ),
                      const Gap(kSpacing),
                      Text(
                        DateFormat(DateFormat.MONTH_DAY).format(
                          daily.dt?.fromTimeStampToDateTime() ?? DateTime.now(),
                        ),
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Gap(kSpacing),
                  Text(
                    mainValues.reverseMap[daily.weather?.first.main]
                            .toString()
                            .capitalize ??
                        "",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Gap(kSpacing),
                  Text(
                    "${daily.temp?.max?.toStringAsFixed(0) ?? 0}º"
                    "/"
                    "${daily.temp?.min?.toStringAsFixed(0) ?? 0}º",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontFamily: temperatureFont,
                      color: Colors.white,
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
        // * Humidity, Wind, Visibility
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentWeather?.humidity != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        "${controller.currentWeather?.humidity ?? 0}%",
                        style: Get.textTheme.bodyMedium,
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
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        "${convertMsToKmh(controller.currentWeather?.windSpeed ?? 0)} km/h",
                        style: Get.textTheme.bodyMedium,
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
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        "${((controller.currentWeather?.visibility ?? 0) / 1000).toStringAsFixed(0)} km",
                        style: Get.textTheme.bodyMedium,
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

        // * UV, Pressure
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentWeather?.uvi != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        UVCalculator.getUVCalculator(
                          controller.currentWeather?.uvi ?? 0,
                        ),
                        style: Get.textTheme.bodyMedium,
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
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        "${controller.currentWeather?.pressure ?? 0} hPa",
                        style: Get.textTheme.bodyMedium,
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

        // * Rain, Snow
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentWeather?.rain?.the1H != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        "${controller.currentWeather?.rain?.the1H ?? 0} mm/h",
                        style: Get.textTheme.bodyMedium,
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
                    color: Get.theme.cardColor.withOpacity(.3),
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
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        "${controller.currentWeather?.snow?.the1H ?? 0} mm/h",
                        style: Get.textTheme.bodyMedium,
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
                color: Get.theme.cardColor.withOpacity(.3),
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
                    style: Get.textTheme.bodyLarge,
                  ),
                  Text(
                    DateFormat(DateFormat.HOUR_MINUTE).format(
                      controller.currentWeather?.sunrise
                              ?.fromTimeStampToDateTime() ??
                          DateTime.now(),
                    ),
                    style: Get.textTheme.bodyMedium,
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
              color: Get.theme.cardColor.withOpacity(.3),
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
                  style: Get.textTheme.bodyLarge,
                ),
                Text(
                  DateFormat(DateFormat.HOUR_MINUTE).format(
                    controller.currentWeather?.sunset
                            ?.fromTimeStampToDateTime() ??
                        DateTime.now(),
                  ),
                  style: Get.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
