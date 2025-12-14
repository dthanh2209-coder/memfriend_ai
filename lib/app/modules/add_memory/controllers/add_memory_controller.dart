import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/values/app_strings.dart';
import '../../../data/models/memory_event.dart';
import '../../../data/models/person.dart';
import '../../../data/providers/database_helper.dart';
import '../../../data/services/storage_service.dart';

class AddMemoryController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Data
  Person? person;
  MemoryEvent? editingMemoryEvent;

  // Observables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasChanges = false.obs;
  final RxBool isImageRequired = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _setupChangeListeners();
  }

  @override
  void onClose() {
    nameController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void _loadData() {
    final arguments = Get.arguments;

    if (arguments is Person) {
      // Adding new memory event
      person = arguments;
    } else if (arguments is Map) {
      // Editing existing memory event
      person = arguments['person'] as Person?;
      editingMemoryEvent = arguments['memoryEvent'] as MemoryEvent?;
      _populateFields();
    } else {
      Get.back();
      Get.snackbar(AppStrings.error.tr, AppStrings.invalidPersonData.tr);
      return;
    }
  }

  void _populateFields() {
    if (editingMemoryEvent != null) {
      nameController.text = editingMemoryEvent!.name;
      contentController.text = editingMemoryEvent!.content ?? '';
      selectedImage.value = File(editingMemoryEvent!.imagePath);
    }
  }

  void _setupChangeListeners() {
    nameController.addListener(_checkForChanges);
    contentController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    if (editingMemoryEvent == null) {
      // New memory event
      hasChanges.value =
          nameController.text.isNotEmpty ||
          contentController.text.isNotEmpty ||
          selectedImage.value != null;
    } else {
      // Editing memory event
      hasChanges.value =
          nameController.text != editingMemoryEvent!.name ||
          contentController.text != (editingMemoryEvent!.content ?? '') ||
          (selectedImage.value != null &&
              selectedImage.value!.path != editingMemoryEvent!.imagePath);
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
        _checkForChanges();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  /// Show image source selection dialog
  void showImageSourceDialog() {
    isImageRequired.value = false;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
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
                      label:  Text(AppStrings.camera.tr),
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
                      label:  Text(AppStrings.gallery.tr),
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

  /// Validate form
  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  /// Save memory event
  Future<void> saveMemoryEvent() async {
    if (!_validateForm()) return;

    if (selectedImage.value == null) {
      isImageRequired.value = true;
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.memoryEventImageRequired.tr,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    if (person?.id == null) {
      Get.snackbar(AppStrings.error.tr, AppStrings.invalidPersonData.tr);
      return;
    }

    try {
      isLoading.value = true;

      String imagePath;

      if (editingMemoryEvent == null ||
          selectedImage.value!.path != editingMemoryEvent!.imagePath) {
        // Save new image
        final savedPath = await _storageService.saveMemoryEventImage(
          selectedImage.value!.path,
          person!.id!,
        );

        if (savedPath == null) {
          throw Exception('Failed to save image');
        }

        imagePath = savedPath;

        // Delete old image if editing
        if (editingMemoryEvent != null) {
          await _storageService.deleteFile(editingMemoryEvent!.imagePath);
        }
      } else {
        // Keep existing image path
        imagePath = editingMemoryEvent!.imagePath;
      }

      final memoryEvent = MemoryEvent(
        id: editingMemoryEvent?.id,
        personId: person!.id!,
        name: nameController.text.trim(),
        content: contentController.text.trim().isEmpty
            ? null
            : contentController.text.trim(),
        imagePath: imagePath,
        updatedTime: DateTime.now(),
      );

      if (editingMemoryEvent == null) {
        // Add new memory event
        await _databaseHelper.insertMemoryEvent(memoryEvent);
      } else {
        // Update existing memory event
        await _databaseHelper.updateMemoryEvent(memoryEvent);
      }

      hasChanges.value = false;
      Get.back(result: true);
      Get.snackbar(
        AppStrings.success.tr,
        AppStrings.memoryEventSaved.tr,
        backgroundColor: Get.theme.colorScheme.tertiary,
        colorText: Get.theme.colorScheme.onTertiary,
      );
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        '${AppStrings.failedToSaveMemoryEvent.tr}: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle back navigation with unsaved changes
  Future<bool> onWillPop() async {
    if (!hasChanges.value) return true;

    final shouldDiscard = await Get.dialog<bool>(
      AlertDialog(
        title: Text(AppStrings.discardChanges.tr),
        content: Text(AppStrings.unsavedChangesWarning.tr),
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

  /// Get page title
  String get pageTitle {
    if (editingMemoryEvent == null) {
      return AppStrings.addMemoryEvent.tr;
    } else {
      return AppStrings.editMemoryEvent.tr;
    }
  }

  /// Get save button text
  String get saveButtonText => AppStrings.save.tr;
}
