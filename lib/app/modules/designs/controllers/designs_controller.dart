import 'package:get/get.dart';
import 'package:weather_app/app/data/local/my_shared_pref.dart';
import 'package:weather_app/app/routes/app_pages.dart';

class DesignsController extends GetxController {
  int designValue = MySharedPref.getDesignNumber();

  setDesignValue(int value) {
    MySharedPref.setDesignNumber(value);
    designValue = value;
    print(designValue);
    update();
    Get.offNamed(Routes.HOME);
    // HomeController homeController = Get.find<HomeController>();
    // homeController.update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
