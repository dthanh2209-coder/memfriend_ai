import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/add_person_controller.dart';

class AddPersonView extends GetView<AddPersonController> {
  const AddPersonView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await controller.onWillPop();
        if (shouldPop) {
          Get.back(result: result);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(controller.pageTitle),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.savePerson,
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    controller.saveButtonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameField(),
            const SizedBox(height: AppSpacing.lg),
            _buildPhoneField(),
            const SizedBox(height: AppSpacing.lg),
            _buildAddressField(),
            const SizedBox(height: AppSpacing.lg),
            _buildRelationField(),
            const SizedBox(height: AppSpacing.lg),
            _buildNoteField(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.name.tr} *',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            hintText: AppStrings.enterName.tr,
            prefixIcon: const Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.nameRequired.tr;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          maxLength: 35,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.phone.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.phoneController,
          decoration: InputDecoration(
            hintText: AppStrings.enterPhone.tr,
            prefixIcon: const Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.address.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.addressController,
          decoration: InputDecoration(
            hintText: AppStrings.enterAddress.tr,
            prefixIcon: const Icon(Icons.location_on),
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildRelationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.relation.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.relationController,
          decoration: InputDecoration(
            hintText: AppStrings.enterRelation.tr,
            prefixIcon: const Icon(Icons.family_restroom),
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.note.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.noteController,
          decoration: InputDecoration(
            hintText: AppStrings.enterNote.tr,
            prefixIcon: const Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          textInputAction: TextInputAction.newline,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          minLines: 3,
        ),
      ],
    );
  }
}
