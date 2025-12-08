import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../data/models/memory_event.dart';

class MemoryEventGrid extends StatelessWidget {
  final List<MemoryEvent> memoryEvents;
  final Function(MemoryEvent)? onMemoryEventTap;

  const MemoryEventGrid({
    super.key,
    required this.memoryEvents,
    this.onMemoryEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.primaryLightColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppBorderRadius.lg),
          bottomRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.memoryEventsCount.tr} (${memoryEvents.length})',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: memoryEvents.length,
              itemBuilder: (context, index) {
                final memoryEvent = memoryEvents[index];
                return _buildMemoryEventItem(memoryEvent);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryEventItem(MemoryEvent memoryEvent) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
        onTap: () => onMemoryEventTap?.call(memoryEvent),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(color: AppTheme.borderColor, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
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
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              memoryEvent.name,
              style: Get.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
