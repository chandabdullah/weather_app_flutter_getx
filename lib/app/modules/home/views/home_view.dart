// ===============================
// home_view.dart
// Clean UI State Management
// ===============================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';

import '../../../services/api_call_status.dart';
import '/app/constants/app_constants.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/modules/home/views/design1_view.dart';
import '/app/modules/home/views/design2_view.dart';
import '/utils/weather_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          body: Stack(
            children: [
              _background(),
              _body(),
            ],
          ),
        );
      },
    );
  }

  Widget _background() {
    return WeatherBg(
      width: Get.width,
      height: Get.height,
      weatherType: WeatherUtils.getWeatherTypeBg(
        WeatherUtils.getRandomDescription(),
      ),
    );
  }

  Widget _body() {
    if (controller.isInitializing ||
        controller.isLoadingLocation ||
        controller.apiCallStatus == ApiCallStatus.loading) {
      return const _LoadingView();
    }

    if (!controller.isInternetConnected && controller.currentWeather == null) {
      return _StateView(
        icon: Icons.wifi_off_rounded,
        title: "No Internet",
        subtitle: "Please connect to internet.",
        buttonText: "Retry",
        onTap: controller.initializeApp,
      );
    }

    if (!controller.isLocationEnabled) {
      return _StateView(
        icon: Icons.location_off_rounded,
        title: "Location Disabled",
        subtitle: "Enable location permission.",
        buttonText: "Enable Now",
        onTap: controller.initializeApp,
      );
    }

    return _design();
  }

  Widget _design() {
    final design = MySharedPref.getDesignNumber();

    if (design == 1) {
      return Design1View(controller: controller);
    }

    return Design2View(controller: controller);
  }
}

// =====================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Stack(
      children: [
        // 1. Rich Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                const Color(0xFF4A90E2), // Lighter blue
                const Color(0xFF1E3A8A), // Deep night blue
              ],
            ),
          ),
        ),

        // 2. Decorative Atmospheric Blobs (The "Aesthetic" secret)
        Positioned(
          top: -50,
          right: -50,
          child: _buildBlurredBlob(250, Colors.white.withValues(alpha: 0.1)),
        ),
        Positioned(
          bottom: 100,
          left: -80,
          child: _buildBlurredBlob(300, Colors.yellow.withValues(alpha: 0.05)),
        ),

        // 3. Main Content
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo/splash_transparent.png",
                  // width: 300,
                  // height: 300,
                ),

                // 4. Glassmorphism Status Card
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(20),
                          Text(
                            "Updating Forecast",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            "Checking local weather stations...",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper for background blobs
  Widget _buildBlurredBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  // Helper for animated cloud
  Widget _buildFloatingCloud() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - (value - 0.5).abs() * 2)),
          child: Icon(
            Icons.cloud_rounded,
            size: 60,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        );
      },
    );
  }
}

// =====================================================

class _StateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  const _StateView({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 60),
            const Gap(18),
            Text(
              title,
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const Gap(24),
            ElevatedButton(
              onPressed: onTap,
              child: Text(buttonText),
            )
          ],
        ),
      ),
    );
  }
}
