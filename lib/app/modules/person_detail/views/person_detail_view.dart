import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_friend/app/core/utils/image_utils.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/person_detail_controller.dart';

class PersonDetailView extends GetView<PersonDetailController> {
  const PersonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      final person = controller.person.value;
      if (person == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          _buildSliverAppBar(person),
        ],

        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildPersonInfo(person),
              _buildFacesSection(),
              _buildMemoryEventsSection(),
              const SizedBox(height: kToolbarHeight * 2),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSliverAppBar(person) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      title: Text(AppStrings.personDetail.tr),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: controller.showPersonActionsMenu,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60), // Space for app bar
                _buildAvatar(),
                const SizedBox(height: AppSpacing.md),
                Flexible(
                  child: Text(
                    person.name,
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Obx(() {
      final latestFace = controller.latestFace;

      return InkWell(
        onTap: () => showFullScreenImage(latestFace?.path ?? ''),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
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
    });
  }

  Widget _buildDefaultAvatar() {
    return const Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
  }

  Widget _buildPersonInfo(person) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.phone, AppStrings.phone.tr, person.phone),
          _buildInfoRow(
            Icons.location_on,
            AppStrings.address.tr,
            person.address,
          ),
          _buildInfoRow(Icons.note, AppStrings.note.tr, person.note),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value?.isNotEmpty == true
                      ? value!
                      : AppStrings.notAvailable.tr,
                  style: value?.isNotEmpty == true
                      ? Get.textTheme.bodyLarge
                      : Get.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.faces.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: controller.goToAddFace,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Obx(() => _buildFacesGrid()),
        ],
      ),
    );
  }

  Widget _buildFacesGrid() {
    if (controller.isLoadingFaces.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.faces.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(Icons.face_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.noFacesFound.tr,
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1,
      ),
      padding: EdgeInsets.zero,
      itemCount: controller.faces.length,
      itemBuilder: (context, index) {
        final face = controller.faces[index];
        return _buildFaceItem(face);
      },
    );
  }

  Widget _buildFaceItem(face) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () => showFullScreenImage(face.path),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: Image.file(
                File(face.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.primaryLightColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.broken_image,
                      color: AppTheme.textSecondaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                onPressed: () => controller.deleteFace(face),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                AppStrings.memoryEvents.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Obx(() => _buildMemoryEventsList()),
        ),
      ],
    );
  }

  Widget _buildMemoryEventsList() {
    if (controller.isLoadingMemoryEvents.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.memoryEvents.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.noMemoryEventsFound.tr,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.memoryEvents.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final memoryEvent = controller.memoryEvents[index];
        return _buildMemoryEventCard(memoryEvent);
      },
    );
  }

  Widget _buildMemoryEventCard(memoryEvent) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.top,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Obx(() {
                      final latestFace = controller.latestFace;
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
                  ),
                ),
          
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLightColor,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          memoryEvent.name,
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  controller.editMemoryEvent(memoryEvent);
                } else if (value == 'delete') {
                  controller.deleteMemoryEvent(memoryEvent);
                }
              },
              itemBuilder: (context) => [
                 PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: AppSpacing.sm),
                      Text(AppStrings.edit.tr),
                    ],
                  ),
                ),
                 PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: AppSpacing.sm),
                      Text(AppStrings.delete.tr),
                    ],
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.all(AppSpacing.sm),
          ),
          if (memoryEvent.content?.isNotEmpty == true) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                memoryEvent.content!,
                style: Get.textTheme.bodyMedium,
              ),
            ),
          ],
          InkWell(
            onTap: () => showFullScreenImage(memoryEvent.imagePath),
            child: SizedBox(
              height: 200,
              child: Image.file(
                File(memoryEvent.imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.primaryLightColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.broken_image,
                      color: AppTheme.textSecondaryColor,
                      size: 60,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: controller.goToAddMemoryEvent,
      child: const Icon(Icons.add),
    );
  }
}
