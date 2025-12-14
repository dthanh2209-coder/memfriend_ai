import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_friend/app/core/utils/image_utils.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/recognition_controller.dart';

class RecognitionView extends GetView<RecognitionController> {
  const RecognitionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Obx(() {
        return Text('${AppStrings.recognition.tr} - ${controller.modeTitle}');
      }),
      actions: [
        Obx(() {
          return IconButton(
            icon: Icon(controller.cameraSwitchIcon),
            onPressed: controller.switchMode,
            tooltip: AppStrings.switchMode.tr,
          );
        }),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // SizedBox(
        //   height: 100,
        //   width: 100,
        //   child: Obx(() {
        //     if (controller.uiImage.value == null) {
        //       return SizedBox();
        //     }
        //     return Image.memory(controller.uiImage.value!);
        //   }),
        // ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildCameraOrImageSection(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildRecognitionResultSection(),
              ),
              Obx(() {
                if (controller.recognitionMode.value == RecognitionMode.image) {
                  return SizedBox();
                }

                return Positioned(
                  top: 24,
                  right: 24,
                  child: FilledButton.tonal(
                    onPressed: controller.switchCamera,
                    child: const Icon(Icons.flip_camera_android),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCameraOrImageSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppTheme.borderColor, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Obx(() {
          if (controller.recognitionMode.value == RecognitionMode.live) {
            return _buildLiveCameraView();
          } else {
            return _buildImageModeView();
          }
        }),
      ),
    );
  }

  Widget _buildLiveCameraView() {
    return Obx(() {
      if (!controller.hasCameraPermission.value) {
        return _buildPermissionDeniedView();
      }

      if (!controller.isCameraInitialized.value ||
          controller.cameraController == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return CameraPreview(controller.cameraController!);
    });
  }

  Widget _buildImageModeView() {
    return Obx(() {
      if (controller.selectedImage.value != null) {
        return Stack(
          children: [
            Image.file(
              controller.selectedImage.value!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                onPressed: controller.showImageSourceDialog,
                backgroundColor: AppTheme.accentColor,
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
            ),
          ],
        );
      }

      return InkWell(
        onTap: controller.showImageSourceDialog,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.primaryLightColor.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.tapToSelectImage.tr,
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPermissionDeniedView() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.cameraPermissionDenied.tr,
            style: Get.textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => controller.checkPermissions(),
            child: Text(AppStrings.grantPermission.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionResultSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.xl),
          topRight: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      constraints: const BoxConstraints(minHeight: 224),
      child: Obx(() {
        if (controller.isRecognizing.value) {
          return _buildRecognizingState();
        }

        if (controller.recognizedPerson.value != null) {
          return _buildRecognizedPersonResult();
        }

        if (controller.recognitionMessage.value.isNotEmpty) {
          return _buildNoPersonFoundResult();
        }

        return _buildInitialState();
      }),
    );
  }

  Widget _buildRecognizingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.recognizing.tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildRecognizedPersonResult() {
    final person = controller.recognizedPerson.value!;

    return InkWell(
      onTap: controller.goToPersonDetail,
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: AppTheme.accentColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Obx(() {
                  final latestFace = controller.recognizedPersonFace.value;
                  return InkWell(
                    onTap: () => showFullScreenImage(latestFace?.path ?? ''),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      width: 54,
                      height: 54,
                      child: ClipOval(
                        clipBehavior: Clip.hardEdge,
                        child: latestFace != null
                            ? Image.file(
                                File(latestFace.path),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar();
                                },
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      if (person.relation?.isNotEmpty == true) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          person.relation!,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.speakRecognitionResult(person);
                  },
                  icon: const Icon(Icons.volume_up),
                  color: AppTheme.accentColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, color: AppTheme.accentColor, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    AppStrings.tapToViewDetails.tr,
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPersonFoundResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 80,
          color: Get.theme.colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          controller.recognitionMessage.value,
          style: Get.textTheme.titleLarge?.copyWith(
            color: Get.theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.face_retouching_natural,
          size: 80,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          controller.recognitionMode.value == RecognitionMode.live
              ? AppStrings.tapCameraToRecognize.tr
              : AppStrings.selectImageToRecognize.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            controller.goToHome();
            break;
          case 1:
            // Already on recognition
            break;
          case 2:
            controller.goToSettings();
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppStrings.home.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.face),
          label: AppStrings.recognition.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppStrings.settings.tr,
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
  }
}
