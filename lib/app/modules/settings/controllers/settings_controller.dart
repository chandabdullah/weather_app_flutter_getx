import 'package:get/get.dart';
import 'package:weather_app/app/modules/home/controllers/home_controller.dart';

import '/app/data/local/my_shared_pref.dart';
import '/app/routes/app_pages.dart';

class SettingsController extends GetxController {
  int selectedDesign = MySharedPref.getDesignNumber();

  void setDesignValue(int value) {
    if (selectedDesign == value) {
      return;
    }

    MySharedPref.setDesignNumber(value);
    selectedDesign = value;
    update();
    // Get.offAllNamed(Routes.HOME);
    HomeController homeController = Get.find<HomeController>();
    homeController.update();
    Get.back();
  }
}
