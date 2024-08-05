import 'dart:ui';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/app/routes/app_pages.dart';
import '/app/constants/app_constants.dart';
import '/app/models/weather_model.dart';
import '/app/modules/home/controllers/home_controller.dart';
import '/app/services/api_call_status.dart';
import '/app/widgets/blur_container.dart';
import '/config/theme/my_gradient.dart';
import '/utils/uv_calculator.dart';
import '/utils/weather_utils.dart';
import '/utils/datetime_utils.dart';

class Design2View extends GetView {
  const Design2View({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      physics: const ScrollPhysics(),
      centerTitle: false,
      // leading: const Icon(
      //   Icons.location_on_rounded,
      //   color: Colors.white,
      // ),
      title: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
          ),
          const Gap(10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "${controller.currentCity}"
                    " - ",
                style: Get.textTheme.bodyLarge?.copyWith(
                  // fontFamily: temperatureFont,
                  color: Get.theme.appBarTheme.foregroundColor,
                ),
                children: [
                  TextSpan(
                    text:
                        "${controller.currentWeather?.temp?.toStringAsFixed(0)}"
                        "ºC",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: Get.theme.appBarTheme.foregroundColor,
                      fontFamily: temperatureFont,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.DESIGNS);
            },
            color: Colors.white,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      headerWidget: Stack(
        children: [
          WeatherBg(
            weatherType: WeatherUtils.getWeatherTypeBg(
              controller.currentWeather?.weather?.first.description,
              // Description.CLEAR_SKY,
              rain: controller.currentWeather?.rain,
              snow: controller.currentWeather?.snow,
              date: controller.currentWeather?.dt,
              sunrise: controller.currentWeather?.sunrise,
              sunset: controller.currentWeather?.sunset,
            ),
            height: double.maxFinite,
            width: Get.width,
          ),
          BlurContainer(
            color: MyGradient.getAppBarColor(
              controller.currentWeather?.weather?.first.description,
            ).withOpacity(.3),
            filter: ImageFilter.blur(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                            ),
                            const Gap(10),
                            Expanded(
                              child: Text(
                                "${controller.currentCity}",
                                style: Get.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const Gap(10),
                            IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.DESIGNS);
                              },
                              color: Colors.white,
                              icon: const Icon(Icons.settings),
                            ),
                          ],
                        ),
                        Text(
                          "Today, ${DateFormat("MMM dd").format(DateTime.now().toLocal())}",
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        // const Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      child: Text(
                                        controller.apiCallStatus ==
                                                ApiCallStatus.success
                                            ? "${controller.currentWeather?.temp?.toStringAsFixed(0)}"
                                            : "__",
                                        style: Get.textTheme.headlineLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 70.sp,
                                          fontFamily: temperatureFont,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      "ºC",
                                      style:
                                          Get.textTheme.headlineLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: temperatureFont,
                                      ),
                                    ),
                                    // child: Icon(
                                    //   WeatherIcons.celsius,
                                    //   size: 40,
                                    //   color: Colors.white,
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "H ${controller.dailyForecast.first.temp?.max?.toStringAsFixed(0) ?? 0}ºC",
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: temperatureFont,
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    "L ${controller.dailyForecast.first.temp?.min?.toStringAsFixed(0) ?? 0}ºC",
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: temperatureFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                          ],
                        ),
                        // const Gap(20),
                        RichText(
                          text: TextSpan(
                            text:
                                "${descriptionValues.reverseMap[controller.currentWeather?.weather?.first.description].toString().capitalize} ",
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: "Feel Like ",
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${controller.currentWeather?.feelsLike ?? 0}ºC",
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontFamily: temperatureFont,
                                ),
                              ),
                            ],
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
      body: [
        Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hourly Forecast",
                style: Get.textTheme.bodyLarge,
              ),
              const Gap(10),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.hourlyForecast.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Gap(10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var hourly = controller.hourlyForecast[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Get.theme.splashColor.withOpacity(.15),
                        border: Border.all(
                          color: Get.theme.splashColor.withOpacity(.5),
                        ),
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        // shape: BoxShape.circle,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SvgPicture.asset(
                              WeatherUtils.getWeatherSvg(
                                hourly.weather?.first.description,
                                date: hourly.dt,
                                sunrise: controller.currentWeather?.sunrise,
                                sunset: controller.currentWeather?.sunset,
                              ),
                            ),
                          ),
                          const Gap(7),
                          Text(
                            DateFormat(DateFormat.HOUR_MINUTE).format(
                              hourly.dt?.fromTimeStampToDateTime() ??
                                  DateTime.now(),
                            ),
                            style: Get.textTheme.bodySmall,
                          ),
                          const Gap(5),
                          Text(
                            "${hourly.temp?.toStringAsFixed(0) ?? 0}ºC",
                            style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: temperatureFont,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Gap(20),
              Text(
                "Daily Forecast",
                style: Get.textTheme.bodyLarge,
              ),
              const Gap(10),
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.dailyForecast.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Gap(10);
                },
                itemBuilder: (BuildContext context, int index) {
                  var daily = controller.dailyForecast[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Get.theme.splashColor.withOpacity(.15),
                      border: Border.all(
                        color: Get.theme.splashColor.withOpacity(.5),
                      ),
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            DateTimeUtils.getDayOrDate(
                              daily.dt?.fromTimeStampToDateTime() ??
                                  DateTime.now(),
                            ),
                            // DateFormat("EEEE, MMM dd").format(
                            //   daily.dt?.fromTimeStampToDateTime() ?? DateTime.now(),
                            // ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Get.textTheme.bodyLarge,
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                WeatherUtils.getWeatherSvg(
                                  daily.weather?.first.description,
                                ),
                                height: 50,
                              ),
                              Expanded(
                                child: Text(
                                  // WeatherUtils.getSmallTextFromDescription(
                                  //   daily.weather?.first.description,
                                  // ),
                                  descriptionValues.reverseMap[
                                              daily.weather?.first.description]
                                          .toString()
                                          .capitalize ??
                                      "",
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(5),
                        Expanded(
                          flex: 3,
                          child: RichText(
                            // "${daily.temp?.eve?.toStringAsFixed(0) ?? 0}ºC",
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              text:
                                  "${daily.temp?.max?.toStringAsFixed(0) ?? 0}º ",
                              style: Get.textTheme.bodySmall?.copyWith(
                                fontFamily: temperatureFont,
                                color: Get.textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      " ${daily.temp?.min?.toStringAsFixed(0) ?? 0}º",
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    fontFamily: temperatureFont,
                                    color: Get.textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Gap(20),
              Text(
                "About Today",
                style: Get.textTheme.bodyLarge,
              ),
              const Gap(10),
              GridView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 1,
                  crossAxisSpacing: kSpacing,
                  mainAxisSpacing: kSpacing,
                ),
                children: [
                  gridContainer(
                    text: "UV Index",
                    value: UVCalculator.getUVCalculator(
                      controller.currentWeather?.uvi ?? 0,
                    ),
                    value2: (controller.currentWeather?.uvi ?? 0) == 0
                        ? ""
                        : " (${controller.currentWeather?.uvi?.toStringAsFixed(0) ?? 0})",
                  ),
                  gridContainer(
                    text: "Humidity",
                    value: "${controller.currentWeather?.humidity ?? 0}",
                    value2: "%",
                  ),
                  gridContainer(
                    text: "Visibility",
                    value:
                        "${((controller.currentWeather?.visibility ?? 0) / 1000).toStringAsFixed(0)}",
                    value2: "km",
                  ),
                  gridContainer(
                    text: "Pressure",
                    value: "${controller.currentWeather?.pressure ?? 0}",
                    value2: "hPa",
                  ),
                  gridContainer(
                    text: "Sunrise",
                    value: DateFormat("hh:mm").format(
                      controller.currentWeather?.sunrise
                              ?.fromTimeStampToDateTime() ??
                          DateTime.now(),
                    ),
                    value2: DateFormat("a").format(
                      controller.currentWeather?.sunrise
                              ?.fromTimeStampToDateTime() ??
                          DateTime.now(),
                    ),
                  ),
                  gridContainer(
                    text: "Sunset",
                    value: DateFormat("hh:mm").format(
                      controller.currentWeather?.sunset
                              ?.fromTimeStampToDateTime() ??
                          DateTime.now(),
                    ),
                    value2: DateFormat("a").format(
                      controller.currentWeather?.sunset
                              ?.fromTimeStampToDateTime() ??
                          DateTime.now(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget gridContainer({
    required String text,
    required String value,
    String? value2,
  }) {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.splashColor.withOpacity(.15),
        border: Border.all(
          color: Get.theme.splashColor.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: Get.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Get.textTheme.headlineMedium,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                  child: Text(
                    value2 ?? "",
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if (value2?.isNotEmpty ?? false)
          //   Text(
          //     value2 ?? "",
          //     style: Get.textTheme.titleMedium,
          //   ),
        ],
      ),
    );
  }
}
