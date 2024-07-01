import 'package:weather_app/app/services/permissions_service.dart';

import '/app/data/local/my_shared_pref.dart';
import '/config/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.prod');

  // init shared preference
  await MySharedPref.init();

  AppPermissions appPermissions =
      await PermissionHandlerService.checkPermissionsForApplication();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Weather App",
          initialRoute: PermissionHandlerService.initialPage(appPermissions),
          getPages: AppPages.routes,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                data: MediaQuery.of(context),
                child: widget!,
              ),
            );
          },
        );
      },
    ),
  );
}
