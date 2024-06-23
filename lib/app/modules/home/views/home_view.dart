import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF054075),
        title: GestureDetector(
          onTap: () {},
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
      ),
      body: Container(
        height: Get.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF053f76),
              Color(0xFF054075),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "31",
                              style: Get.textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              WeatherIcons.celsius,
                              size: 50,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(20),
                    const Icon(
                      WeatherIcons.cloudy,
                      size: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
                const Gap(10),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: Colors.grey[300],
                    color: Colors.white.withOpacity(.3),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: Colors.grey[300],
                    color: Colors.white.withOpacity(.3),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Hourly Forecast",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: Colors.grey[300],
                    color: Colors.white.withOpacity(.3),
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
  }
}
