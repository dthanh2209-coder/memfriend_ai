import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/values/app_strings.dart';
import '../../../data/models/person.dart';
import '../../../data/services/face_recognition_service.dart';
import '../../../data/services/storage_service.dart';

class AddFaceController extends GetxController {
  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  Rx<List<double>?> vectorObs = Rx<List<double>?>(null);

  // Person data
  Person? person;

  // Selected image
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasValidFace = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPersonData();
  }

  void _loadPersonData() {
    final arguments = Get.arguments;
    if (arguments is Person) {
      person = arguments;
    } else {
      Get.back();
      Get.snackbar(AppStrings.error.tr, AppStrings.invalidPersonData.tr);
    }
  }

  /// Pick image from camera or gallery
  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        _validateFaceImage();
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        '${AppStrings.failedToPickImage.tr}: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  /// Show image source selection dialog
  void showImageSourceDialog() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.selectImageSource.tr,
                style: Get.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        pickImage(fromCamera: true);
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text(AppStrings.camera.tr),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        pickImage(fromCamera: false);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text(AppStrings.gallery.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Validate if the selected image contains a valid face
  Future<void> _validateFaceImage() async {
    if (selectedImage.value == null) {
      hasValidFace.value = false;
      return;
    }

    try {
      isLoading.value = true;

      // Use face2vector to check if image contains a valid face
      vectorObs.value = await _faceRecognitionService
          .convertImageFileToFaceVector(selectedImage.value!.path);
      hasValidFace.value = vectorObs.value != null;

      if (!hasValidFace.value) {
        _showInvalidFaceDialog();
      }
    } catch (e) {
      hasValidFace.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Show invalid face dialog
  void _showInvalidFaceDialog() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                AppStrings.invalidFaceImage.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(AppStrings.invalidFaceImage.tr, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(AppStrings.keepImage.tr),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        showImageSourceDialog();
                      },
                      child: Text(AppStrings.tryAnother.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Save face
  Future<void> saveFace() async {
    if (selectedImage.value == null || person?.id == null) {
      Get.snackbar(AppStrings.error.tr, 'Please select an image');
      return;
    }

    try {
      isLoading.value = true;

      // Save image to app storage
      final savedPath = await _storageService.saveFaceImage(
        selectedImage.value!.path,
        person!.id!,
      );

      if (savedPath == null) {
        throw Exception('Failed to save image');
      }

      // Add face to database using face recognition service
      final success = await _faceRecognitionService.addFace(
        person!.id!,
        savedPath,
        vectorObs.value!,
      );

      if (success) {
        Get.back(result: true, closeOverlays: true);
        Get.snackbar(
          AppStrings.success.tr,
          AppStrings.faceAdded.tr,
          backgroundColor: Get.theme.colorScheme.tertiary,
          colorText: Get.theme.colorScheme.onTertiary,
          isDismissible: true,
        );
      } else {
        // Clean up saved file if face addition failed
        await _storageService.deleteFile(savedPath);
        throw Exception('Failed to process face image');
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        '${AppStrings.failedToSaveFace.tr}: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle back navigation
  Future<bool> onWillPop() async {
    if (selectedImage.value != null) {
      final shouldDiscard = await Get.dialog<bool>(
        AlertDialog(
          title: Text(AppStrings.discardFace.tr),
          content: Text(AppStrings.discardFaceConfirmation.tr),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(AppStrings.cancel.tr),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text(AppStrings.discard.tr),
            ),
          ],
        ),
      );
      return shouldDiscard ?? false;
    }
    return true;
  }

  /// Get page title
  String get pageTitle => AppStrings.addFace.tr;
}
