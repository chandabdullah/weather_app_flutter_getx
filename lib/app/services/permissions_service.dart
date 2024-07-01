import '/app/data/local/my_shared_pref.dart';
import 'package:get/get.dart';
import '/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppPermissions {
  DONE,
  LOCATION,
  NOTIFICATION,
}

class PermissionHandlerService {
  PermissionHandlerService._();

  static String initialPage(appPermissions) {
    return appPermissions == AppPermissions.LOCATION
        ? Routes.LOCATION_PERMISSION
        : AppPages.INITIAL;
  }

  /// =================================================
  /// Check All Application Permissions
  /// =================================================

  static Future<AppPermissions> checkPermissionsForApplication() async {
    PermissionStatus locationStatus = await Permission.locationWhenInUse.status;
    if (locationStatus.isDenied) {
      return AppPermissions.LOCATION;
    } else if (locationStatus.isGranted) {
    } else if (locationStatus.isPermanentlyDenied) {
      // await openAppSettings();
      return AppPermissions.LOCATION;
    }

    return AppPermissions.DONE;
  }

  /// =================================================
  /// Request Location Permission
  /// =================================================

  static Future<bool> requestLocationPermission() async {
    ServiceStatus isEnabled = await Permission.locationWhenInUse.serviceStatus;

    if (isEnabled.isEnabled) {
      var permission = await Permission.locationWhenInUse.request();

      if (permission.isLimited || permission.isGranted) {
        return true;
      } else {
        await openAppSettings();
      }
    }
    return false;
  }

  /// =================================================
  /// Go to Permission Pages
  /// =================================================

  static goToPermissionPage(AppPermissions appPermissions) {
    if (appPermissions == AppPermissions.LOCATION) {
      Get.offAllNamed(Routes.LOCATION_PERMISSION);
      return;
    }
    Get.offAllNamed(initialPage(appPermissions));
  }
}
