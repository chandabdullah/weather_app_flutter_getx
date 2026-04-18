import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/app/constants/app_constants.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your weather layout",
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "Switch between the available home screen designs. Your selection is saved and applied immediately.",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: .72),
                    ),
                  ),
                  const Gap(20),
                  _DesignOptionCard(
                    title: "Design 1",
                    subtitle:
                        "Glassmorphism dashboard with rich cards and a premium hero section.",
                    preview: const _ImagePreview(
                      assetPath: 'assets/presentation/faisalabad.png',
                    ),
                    isSelected: controller.selectedDesign == 1,
                    onTap: () => controller.setDesignValue(1),
                  ),
                  const Gap(16),
                  _DesignOptionCard(
                    title: "Design 2",
                    subtitle:
                        "Draggable layered layout with a compact summary and expandable details.",
                    preview: const _ImagePreview(
                      assetPath: 'assets/design_2/faisalabad.png',
                    ),
                    isSelected: controller.selectedDesign == 2,
                    onTap: () => controller.setDesignValue(2),
                  ),
                  const Gap(16),
                  _DesignOptionCard(
                    title: "Design 3",
                    subtitle:
                        "Modern dashboard experience with bold sections, clean spacing, and quick-scan data.",
                    preview: const _ImagePreview(
                      assetPath: 'assets/design_3/design_3.png',
                    ),
                    isSelected: controller.selectedDesign == 3,
                    onTap: () => controller.setDesignValue(3),
                  ),
                ],
              ),
            ),
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
    required this.preview,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget preview;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.cardColor,
            border: Border.all(
              color: isSelected
                  ? theme.primaryColor
                  : theme.dividerColor.withValues(alpha: .15),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? theme.primaryColor.withValues(alpha: .18)
                    : Colors.black.withValues(alpha: .05),
                blurRadius: isSelected ? 22 : 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: preview,
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isSelected ? theme.primaryColor : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? theme.primaryColor
                            : theme.dividerColor.withValues(alpha: .45),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
              const Gap(8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color:
                      theme.textTheme.bodyMedium?.color?.withValues(alpha: .72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.assetPath,
  });

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF67C6FF),
            Color(0xFF2B7BFF),
            Color(0xFF113D8F),
          ],
        ),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Design3Preview extends StatelessWidget {
  const _Design3Preview({
    required this.assetPath,
  });

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3E7BFA),
            Color(0xFF1C3F93),
            Color(0xFF101A3E),
          ],
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(8),
              Container(
                width: 90,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .75),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 120,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const Gap(12),
          Row(
            children: List.generate(
              3,
              (_) => Expanded(
                child: Container(
                  height: 68,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
