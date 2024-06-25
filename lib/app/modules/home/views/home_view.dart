import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:weather_app/app/constants/app_constants.dart';
import 'package:weather_app/app/routes/app_pages.dart';
import 'package:weather_app/config/theme/my_gradient.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              Get.toNamed(Routes.LOCATIONS);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                Gap(10),
                Text(
                  "Faisalabad",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          centerTitle: false,
          actions: [
            Text(
              DateFormat(DateFormat.ABBR_MONTH_DAY).format(DateTime.now()),
              style: Get.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            const Gap(20),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: kPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "31",
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
                    ),
                  ],
                ),
                // Image.network(
                //   'https://openweathermap.org/img/wn/02d@2x.png',
                //   height: 100,
                //   width: 100,
                // ),
                const Icon(
                  WeatherIcons.cloudy,
                  size: 50,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          height: Get.height,
          decoration: BoxDecoration(
            gradient: MyGradient.defaultGradient(),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const Gap(10),
                  Text(
                    "Party Cloud",
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    "33º / 25º",
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    "Feel like 32ºC",
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Gap(20),
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
                          "Rain possible this evening",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                "94%",
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
                                "7km/h",
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
                                "1 km",
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                "0.21 mm/h",
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
                                "0.11 mm/h",
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),

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
                                for (var item in [0, 0, 0, 0, 0, 0, 0, 0])
                                  SizedBox(
                                    height: 100,
                                    width: 75,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "4:30PM",
                                          style:
                                              Get.textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Icon(
                                          WeatherIcons.day_sunny,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "30ºC",
                                          style:
                                              Get.textTheme.bodySmall?.copyWith(
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
                          itemCount: 7,
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      WeatherIcons.cloudy,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const Gap(20),
                                    Text(
                                      "Today",
                                      style: Get.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Text(
                                  "Cloudy",
                                  style: Get.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const Gap(20),
                                Text(
                                  "20º/19º",
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
