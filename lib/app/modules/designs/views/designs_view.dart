import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:weather_app/app/constants/app_constants.dart';
import 'package:weather_app/app/data/local/my_shared_pref.dart';

import '../controllers/designs_controller.dart';

class DesignsView extends GetView<DesignsController> {
  const DesignsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesignsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Designs'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(kPadding),
          height: Get.height,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (controller.designValue == 1) return;
                    controller.setDesignValue(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 3,
                          color: Get.theme.splashColor,
                          blurStyle: BlurStyle.normal,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(kPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/presentation/faisalabad.png',
                          // height: 500,
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                              groupValue: controller.designValue,
                              onChanged: (val) {
                                if (controller.designValue == 1) return;
                                controller.setDesignValue(1);
                              },
                              value: 1,
                            ),
                            Text(
                              "Design 1",
                              style: Get.textTheme.bodyLarge,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (controller.designValue == 2) return;
                    controller.setDesignValue(2);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 3,
                          color: Get.theme.splashColor,
                          blurStyle: BlurStyle.normal,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(kPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/design_2/faisalabad.png',
                          // height: 500,
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                              groupValue: controller.designValue,
                              onChanged: (val) {
                                if (controller.designValue == 2) return;
                                controller.setDesignValue(2);
                              },
                              value: 2,
                            ),
                            Text(
                              "Design 2",
                              style: Get.textTheme.bodyLarge,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
