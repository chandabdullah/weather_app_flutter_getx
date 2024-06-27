import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
        appBar: AppBar(
          // backgroundColor: Get.theme.primaryColor,
          backgroundColor: MyGradient.getAppBarColor(
            controller.currentWeather?.weather?.first.description,
            // Description.FEW_CLOUDS,
          ),
          elevation: 0,
          title: GestureDetector(
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
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          centerTitle: false,
          actions: [
            // Text(
            //   DateFormat(DateFormat.ABBR_MONTH_DAY).format(DateTime.now()),
            //   style: Get.textTheme.bodyLarge?.copyWith(
            //     color: Colors.white,
            //   ),
            // ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
            const Gap(10),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Row(
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
                      if (controller
                              .currentWeather?.weather?.first.description !=
                          null)
                        //   Image.network(
                        //     'https://openweathermap.org/img/wn/${controller.currentWeather?.weather?.first.icon}@2x.png',
                        //     height: 100,
                        //     width: 100,
                        //   ),
                        Icon(
                          WeatherUtils.getWeatherIcon(
                            controller
                                .currentWeather?.weather?.first.description,
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
                      if (controller.currentWeather?.weather?.first.main !=
                          null)
                        Text(
                          descriptionValues.reverseMap[controller.currentWeather
                                      ?.weather?.first.description]
                                  .toString()
                                  .capitalize ??
                              "",
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      Text(
                        "Feel like ${controller.currentWeather?.feelsLike?.toStringAsFixed(0)}ºC",
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Gap(5),
                    ],
                  ),
                const Gap(20),
              ],
            ),
          ),
        ),
        body: Container(
          height: Get.height,
          decoration: BoxDecoration(
            gradient: MyGradient.backgroundGradient(
              controller.currentWeather?.weather?.first.description,
              // Description.FEW_CLOUDS,
            ),
          ),
          child: MyWidgetsAnimator(
            apiCallStatus: controller.apiCallStatus,
            loadingWidget: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            successWidget: () => SmartRefresher(
              controller: controller.smartRefreshController,
              onRefresh: () async {
                await controller.getWeatherInfo();
                controller.smartRefreshController.refreshCompleted();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kPadding),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const Gap(20),
                      // Container(
                      //   padding: const EdgeInsets.all(kSpacing),
                      //   decoration: BoxDecoration(
                      //     color: Get.theme.cardColor.withOpacity(.3),
                      //     borderRadius: BorderRadius.circular(7),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.stretch,
                      //     children: [
                      //       Text(
                      //         "Rain possible this evening",
                      //         textAlign: TextAlign.center,
                      //         style: Get.textTheme.bodyLarge?.copyWith(
                      //           color: Colors.white,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // const Gap(20),

                      // * Hourly Forecast
                      Container(
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
                              height: 100,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var hourly
                                        in controller.hourlyForecast)
                                      SizedBox(
                                        height: 100,
                                        width: 75,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              DateFormat(DateFormat.HOUR_MINUTE)
                                                  .format(
                                                hourly.dt
                                                        ?.fromTimeStampToDateTime() ??
                                                    DateTime.now(),
                                              ),
                                              style: Get.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                            // Image.network(
                                            //   'https://openweathermap.org/img/wn/${hourly.weather?.first.icon}@2x.png',
                                            //   height: 50,
                                            //   width: 50,
                                            // ),
                                            Icon(
                                              WeatherUtils.getWeatherIcon(
                                                hourly
                                                    .weather?.first.description,
                                                date: hourly.dt,
                                                sunrise: controller
                                                    .currentWeather?.sunrise,
                                                sunset: controller
                                                    .currentWeather?.sunset,
                                              ),
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "${hourly.temp?.toStringAsFixed(0) ?? 0}ºC",
                                              style: Get.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),

                      // * Daily Forecast
                      Container(
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  color: Colors.white,
                                  height: 25,
                                  thickness: .5,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                Daily daily = controller.dailyForecast[index];

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          WeatherUtils.getWeatherIcon(
                                            daily.weather?.first.description,
                                            // date: daily.dt,
                                            // sunrise: controller
                                            //     .currentWeather?.sunrise,
                                            // sunset: controller
                                            //     .currentWeather?.sunset,
                                          ),
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        const Gap(20),
                                        Text(
                                          DateFormat(DateFormat.MONTH_DAY)
                                              .format(
                                            daily.dt?.fromTimeStampToDateTime() ??
                                                DateTime.now(),
                                          ),
                                          style:
                                              Get.textTheme.bodyLarge?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    Text(
                                      mainValues.reverseMap[
                                                  daily.weather?.first.main]
                                              .toString()
                                              .capitalize ??
                                          "",
                                      style: Get.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Gap(20),
                                    Text(
                                      "${daily.temp?.max?.toStringAsFixed(0) ?? 0}º"
                                      "/"
                                      "${daily.temp?.min?.toStringAsFixed(0) ?? 0}º",
                                      style: Get.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),

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
                            const Gap(20),
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
                            const Gap(20),
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
                        const Gap(20),

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
                          if (controller.currentWeather?.uvi != null)
                            const Gap(20),
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
                        const Gap(20),

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
                            const Gap(20),
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
                        const Gap(20),

                      // * Sunrise, Sunset
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
                          const Gap(20),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
