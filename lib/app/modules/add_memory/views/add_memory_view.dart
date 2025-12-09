import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/add_memory_controller.dart';

class AddMemoryView extends GetView<AddMemoryController> {
  const AddMemoryView({super.key});

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
    return AppBar(
      title: Text(controller.pageTitle),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.saveMemoryEvent,
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
            // _buildContentField(),
            // const SizedBox(height: AppSpacing.lg),
            _buildImageSection(),
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
          '${AppStrings.memoryEventName.tr} *',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.nameController,
          decoration:  InputDecoration(
            hintText: AppStrings.enterEventName.tr,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.memoryEventNameRequired.tr;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          minLines: 3,
        ),
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.memoryEventContent.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller.contentController,
          decoration: const InputDecoration(
            hintText: AppStrings.enterEventDescription,
            prefixIcon: Icon(Icons.description),
            alignLabelWithHint: true,
          ),
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.memoryEventImage.tr} *',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(child: _buildImageContainer()),
      ],
    );
  }

  Widget _buildImageContainer() {
    return Obx(() {
      final selectedImage = controller.selectedImage.value;

      return Container(
        height: 200,
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
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: controller.showImageSourceDialog,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
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
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(
              color: controller.isImageRequired.value
                  ? AppTheme.errorColor
                  : AppTheme.borderColor,
              width: 2,
            ),
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 60,
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.addMemoryImage.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.tapToSelectMemoryImage.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageSelector() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.pickImage(fromCamera: true),
            icon: const Icon(Icons.camera_alt),
            label:  Text(AppStrings.camera.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.pickImage(fromCamera: false),
            icon: const Icon(Icons.photo_library),
            label:  Text(AppStrings.gallery.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : controller.saveMemoryEvent,
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
                controller.saveButtonText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
