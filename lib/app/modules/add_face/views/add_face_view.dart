import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/add_face_controller.dart';

class AddFaceView extends GetView<AddFaceController> {
  const AddFaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await controller.onWillPop();
          if (shouldPop) {
            Get.back(result: result);
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: Text(controller.pageTitle), actions: [
      
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  controller.person?.name ?? '',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildImageContainer(),
                const SizedBox(height: AppSpacing.xl),
                _buildImageSelector(),
                const SizedBox(height: AppSpacing.xl),
                _buildValidationStatus(),
              ],
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Obx(() {
      final selectedImage = controller.selectedImage.value;

      return Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: AppTheme.borderColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: selectedImage != null
              ? Stack(
                  children: [
                    Image.file(
                      selectedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    if (controller.isLoading.value)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                AppStrings.validatingFace.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _buildFaceValidationIcon(),
                    ),
                  ],
                )
              : _buildEmptyImageState(),
        ),
      );
    });
  }

  Widget _buildEmptyImageState() {
    return InkWell(
      onTap: controller.showImageSourceDialog,
      child: Container(
        color: AppTheme.primaryLightColor.withOpacity(0.1),
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 80, color: AppTheme.primaryColor),
            SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.tapToAddFaceImage.tr,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.selectClearFacePhoto.tr,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceValidationIcon() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: controller.hasValidFace.value
              ? AppTheme.successColor
              : Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Icon(
          controller.hasValidFace.value ? Icons.check : Icons.warning,
          color: Colors.white,
          size: 20,
        ),
      );
    });
  }

  Widget _buildImageSelector() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.pickImage(fromCamera: true),
            icon: const Icon(Icons.camera_alt),
            label: Text(AppStrings.camera.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.pickImage(fromCamera: false),
            icon: const Icon(Icons.photo_library),
            label: Text(AppStrings.gallery.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationStatus() {
    return Obx(() {
      if (controller.selectedImage.value == null) {
        return const SizedBox.shrink();
      }

      if (controller.isLoading.value) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  AppStrings.validatingFace.tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: controller.hasValidFace.value
              ? AppTheme.successColor.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: controller.hasValidFace.value
                ? AppTheme.successColor.withOpacity(0.3)
                : Colors.orange.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              controller.hasValidFace.value
                  ? Icons.check_circle
                  : Icons.warning,
              color: controller.hasValidFace.value
                  ? AppTheme.successColor
                  : Colors.orange,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.hasValidFace.value
                        ? AppStrings.validFaceDetected.tr
                        : AppStrings.faceNotClearlyDetected.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: controller.hasValidFace.value
                          ? AppTheme.successColor
                          : Colors.orange[700],
                    ),
                  ),
                  if (!controller.hasValidFace.value) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.faceDetectionWarning.tr,
                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton(
        onPressed:
            controller.isLoading.value ||
                controller.selectedImage.value == null ||
                controller.vectorObs.value == null
            ? null
            : controller.saveFace,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),

        child: controller.isLoading.value
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                AppStrings.save.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
