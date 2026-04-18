import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '/app/constants/app_constants.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a PageController to manage the horizontal slider
    final PageController pageController = PageController(
      viewportFraction: 0.85, // Shows a peek of the next card
      initialPage: controller.selectedDesign - 1,
    );

    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Appearance'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Layout Gallery",
                          style: Get.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        // Aesthetic Counter
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Get.theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${controller.selectedDesign} of 3 Available",
                            style: TextStyle(
                              color: Get.theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      "Swipe to explore weather designs. Tap to apply.",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal Slider
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _DesignOptionCard(
                      title: "Royal Glass",
                      subtitle: "Glassmorphism with premium hero sections.",
                      assetPath: 'assets/presentation/faisalabad.png',
                      isSelected: controller.selectedDesign == 1,
                      onTap: () => controller.setDesignValue(1),
                    ),
                    _DesignOptionCard(
                      title: "Minimalist",
                      subtitle: "Clean, draggable layers for data lovers.",
                      assetPath: 'assets/design_2/faisalabad.png',
                      isSelected: controller.selectedDesign == 2,
                      onTap: () => controller.setDesignValue(2),
                    ),
                    _DesignOptionCard(
                      title: "Modern Dash",
                      subtitle: "Bold typography and quick-scan metrics.",
                      assetPath: 'assets/design_3/design_3.png',
                      isSelected: controller.selectedDesign == 3,
                      onTap: () => controller.setDesignValue(3),
                    ),
                  ],
                ),
              ),

              // Progress Indicator Dots
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    bool active = (controller.selectedDesign - 1) == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: active ? 24 : 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Get.theme.primaryColor
                            : Get.theme.dividerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DesignOptionCard extends StatelessWidget {
  const _DesignOptionCard({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? theme.primaryColor.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                children: [
                  // The Vertical Image (Background of the card)
                  Positioned.fill(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Bottom Info Overlay (Glassmorphism)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor.withValues(alpha: 0.7),
                            border: Border(
                              top: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(Icons.check_circle,
                                        color: theme.primaryColor),
                                ],
                              ),
                              const Gap(4),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withValues(alpha: 0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Selection Border
                  if (isSelected)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: theme.primaryColor, width: 3),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
