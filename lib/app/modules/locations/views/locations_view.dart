import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:weather_app/app/constants/app_constants.dart';
import 'package:weather_icons/weather_icons.dart';

import '../controllers/locations_controller.dart';

class LocationsView extends GetView<LocationsController> {
  const LocationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Get.theme.cardColor,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: Get.theme.primaryColor,
        ),
      ),
      appBar: AppBar(
        title: const Text('Locations'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPadding,
            ),
            child: TextField(
              cursorColor: Get.theme.primaryColor,
              decoration: InputDecoration(
                hintText: "Search for a city...",
                hintStyle: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.cardColor.withOpacity(.5),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(kPadding),
          itemCount: 3,
          separatorBuilder: (BuildContext context, int index) {
            return const Gap(20);
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(kPadding),
              decoration: BoxDecoration(
                color: Get.theme.cardColor.withOpacity(.3),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Paris, France",
                          style: Get.textTheme.titleLarge,
                        ),
                        const Gap(20),
                        Text(
                          "May 21",
                          style: Get.textTheme.bodyMedium,
                        ),
                        const Gap(10),
                        Text(
                          "H: 28º " " - " "L: 18º",
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          WeatherIcons.cloudy,
                          color: Get.theme.cardColor,
                          size: 40,
                        ),
                      ),
                      Text(
                        "21º",
                        style: Get.textTheme.headlineLarge,
                      ),
                      Text(
                        "Mostly Cloudy",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
