import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import '/app/constants/app_constants.dart';

import '../controllers/location_permission_controller.dart';

class LocationPermissionView extends GetView<LocationPermissionController> {
  const LocationPermissionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.height / 2,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 50,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 30,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 100,
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 30,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      bottom: 100,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 20,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      bottom: 100,
                      right: 50,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 20,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 50,
                      right: 50,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 20,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 100,
                      right: 50,
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 40,
                      bottom: 50,
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Gap(30),
                    Text(
                      "Enable Location",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "To provide near by drivers to your location please grant permission for the application to access your device s geo location",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    // const Gap(20),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: kPadding,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Get.theme.primaryColor,
                        ),
                      ),
                      onPressed: controller.onEnablePermissions,
                      child: const Text("Enable Now"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
