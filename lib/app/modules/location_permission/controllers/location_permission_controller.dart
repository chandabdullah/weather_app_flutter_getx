import 'package:get/get.dart';
import 'package:weather_app/app/services/permissions_service.dart';

class LocationPermissionController extends GetxController {
  onEnablePermissions() async {
    bool isEnabled = await PermissionHandlerService.requestLocationPermission();
    if (isEnabled) {
      AppPermissions appPermissions =
          await PermissionHandlerService.checkPermissionsForApplication();

      PermissionHandlerService.goToPermissionPage(appPermissions);
    }
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
