import 'dart:ui';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/modules/home/views/design1_view.dart';
import '/app/modules/home/views/design2_view.dart';
import '/app/routes/app_pages.dart';
import '/app/components/my_widgets_animator.dart';
import '/app/constants/app_constants.dart';
import '/app/models/weather_model.dart';
import '/app/services/api_call_status.dart';
import '/config/theme/my_gradient.dart';
import '/utils/calculation.dart';
import '/utils/uv_calculator.dart';
import '/utils/weather_utils.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
import '/utils/datetime_utils.dart';
import 'package:glass/glass.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
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

          body: Stack(
            children: [
              WeatherBg(
                width: Get.width,
                height: Get.height,
                weatherType: WeatherUtils.getWeatherTypeBg(
                  WeatherUtils.getRandomDescription(),
                ),
              ),
              controller.isLoadingLocation
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
                  : !controller.isInternetConnected
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.wifi_off_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                              const Gap(kSpacing),
                              Text(
                                "No Internet Connection!",
                                style: Get.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(20),
                              TextButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.white.withOpacity(.2),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Get.theme.primaryColor,
                                  ),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: kPadding,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  controller.onReady();
                                },
                                child: Text(
                                  "Enable Now",
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 20,
                                  ),
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
                                      elevation: MaterialStateProperty.all(0),
                                      overlayColor: MaterialStateProperty.all(
                                        Colors.white.withOpacity(.2),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Get.theme.primaryColor,
                                      ),
                                      padding: MaterialStateProperty.all(
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
                                      style:
                                          Get.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        // fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : MyWidgetsAnimator(
                              apiCallStatus: controller.apiCallStatus,
                              loadingWidget: () => SizedBox(
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
                              ),
                              successWidget: () =>
                                  MySharedPref.getDesignNumber() == 1
                                      ? Design1View(
                                          controller: controller,
                                        )
                                      : Design2View(
                                          controller: controller,
                                        ),
                            ),
            ],
          ),
        );
      },
    );
  }
}
