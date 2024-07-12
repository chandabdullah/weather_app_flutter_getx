import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.language),
                title: Text(
                  "Language",
                  style: Get.textTheme.titleMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "English",
                      style: Get.textTheme.bodySmall,
                    ),
                    const Gap(10),
                    Icon(Icons.arrow_right_alt),
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
