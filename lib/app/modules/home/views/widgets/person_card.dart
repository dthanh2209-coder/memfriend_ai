import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../data/models/face.dart';
import '../../../../data/models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final Face? latestFace;
  final VoidCallback? onTap;
  final VoidCallback? onExpand;
  final VoidCallback? onDelete;
  final bool isExpanded;
  final bool hasMemoryEvents;

  const PersonCard({
    super.key,
    required this.person,
    this.latestFace,
    this.onTap,
    this.onExpand,
    this.onDelete,
    this.isExpanded = false,
    this.hasMemoryEvents = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildPersonInfo()),
                _buildActionButtons(context),
              ],
            ),
            if (hasMemoryEvents) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildExpandButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryLightColor,
        border: Border.all(color: AppTheme.borderColor, width: 2),
      ),
      child: ClipOval(
        child: latestFace != null
            ? Image.file(
                File(latestFace!.path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(Icons.person, size: 32, color: AppTheme.primaryColor);
  }

  Widget _buildPersonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          person.name,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (person.phone?.isNotEmpty == true) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  person.phone!,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (person.relation?.isNotEmpty == true) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.family_restroom,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  person.relation!,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, color: AppTheme.errorColor),
              const SizedBox(width: AppSpacing.sm),
              Text(AppStrings.delete.tr),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandButton() {
    return InkWell(
      onTap: onExpand,
      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isExpanded
                  ? AppStrings.hideMemoryEvents.tr
                  : AppStrings.showMemoryEvents.tr,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
