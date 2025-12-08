import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_strings.dart';
import '../../../data/models/person.dart';
import '../../../data/providers/database_helper.dart';

class AddPersonController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final relationController = TextEditingController();
  final noteController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool hasChanges = false.obs;

  // Person being edited (null for new person)
  Person? editingPerson;

  @override
  void onInit() {
    super.onInit();

    // Check if we're editing an existing person
    final arguments = Get.arguments;
    if (arguments is Person) {
      editingPerson = arguments;
      _populateFields();
    }

    // Listen for changes
    _setupChangeListeners();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    relationController.dispose();
    noteController.dispose();
    super.onClose();
  }

  void _populateFields() {
    if (editingPerson != null) {
      nameController.text = editingPerson!.name;
      phoneController.text = editingPerson!.phone ?? '';
      addressController.text = editingPerson!.address ?? '';
      relationController.text = editingPerson!.relation ?? '';
      noteController.text = editingPerson!.note ?? '';
    }
  }

  void _setupChangeListeners() {
    nameController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    addressController.addListener(_checkForChanges);
    relationController.addListener(_checkForChanges);
    noteController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    if (editingPerson == null) {
      // New person - check if any field has content
      hasChanges.value =
          nameController.text.isNotEmpty ||
          phoneController.text.isNotEmpty ||
          addressController.text.isNotEmpty ||
          relationController.text.isNotEmpty ||
          noteController.text.isNotEmpty;
    } else {
      // Editing - check if any field has changed
      hasChanges.value =
          nameController.text != editingPerson!.name ||
          phoneController.text != (editingPerson!.phone ?? '') ||
          addressController.text != (editingPerson!.address ?? '') ||
          relationController.text != (editingPerson!.relation ?? '') ||
          noteController.text != (editingPerson!.note ?? '');
    }
  }

  /// Validate form
  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  /// Save person
  Future<void> savePerson() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      final person = Person(
        id: editingPerson?.id,
        name: nameController.text.trim(),
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        address: addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
        relation: relationController.text.trim().isEmpty
            ? null
            : relationController.text.trim(),
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
      );

      if (editingPerson == null) {
        // Add new person
        await _databaseHelper.insertPerson(person);
      } else {
        // Update existing person
        await _databaseHelper.updatePerson(person);
      }

      hasChanges.value = false;
      Get.back(result: true, closeOverlays: true);
      Get.snackbar(
        AppStrings.success.tr,
        AppStrings.personSaved.tr,
        backgroundColor: Get.theme.colorScheme.tertiary,
        colorText: Get.theme.colorScheme.onTertiary,
        isDismissible: true,
      );
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        '${AppStrings.failedToSavePerson.tr}: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        isDismissible: true,
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
  String get pageTitle =>
      editingPerson == null ? AppStrings.addPerson.tr : AppStrings.editPerson.tr;

  /// Get save button text
  String get saveButtonText => AppStrings.save.tr;
}
