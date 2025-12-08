import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_friend/app/core/utils/image_utils.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/models/person.dart';
import '../controllers/home_controller.dart';
import 'widgets/memory_event_grid.dart';
import 'widgets/person_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Obx(() {
        return controller.isSearching.value
            ? SizedBox(
                height: kToolbarHeight - AppSpacing.sm,
                child: _buildSearchField(),
              )
            : Text(AppStrings.personManagement.tr);
      }),
      actions: [
        Obx(() {
          return IconButton(
            icon: Icon(
              controller.isSearching.value ? Icons.close : Icons.search,
            ),
            onPressed: controller.toggleSearch,
          );
        }),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: AppStrings.searchPerson.tr,
        border: InputBorder.none,
      ),
      onChanged: controller.searchPersons,
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredPersons.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: controller.filteredPersons.length,
          itemBuilder: (context, index) {
            final person = controller.filteredPersons[index];
            return _buildPersonItem(person);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: AppSpacing.lg),
          Text(
            controller.searchQuery.value.isEmpty
                ? AppStrings.noPeopleFound.tr
                : '${AppStrings.noResultsFound.tr} "${controller.searchQuery.value}"',
            style: Get.textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (controller.searchQuery.value.isEmpty)
            ElevatedButton.icon(
              onPressed: controller.goToAddPerson,
              icon: const Icon(Icons.add),
              label: Text(AppStrings.addPerson.tr),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonItem(Person person) {
    if (person.id == null) return const SizedBox.shrink();

    return Obx(() {
      final isExpanded = controller.isPersonExpanded(person.id!);
      final latestFace = controller.getLatestFace(person.id!);
      final memoryEvents = controller.getMemoryEvents(person.id!);

      return Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          children: [
            PersonCard(
              person: person,
              latestFace: latestFace,
              onTap: () => controller.goToPersonDetail(person),
              onExpand: () => controller.togglePersonExpansion(person.id!),
              onDelete: () => controller.deletePerson(person),
              isExpanded: isExpanded,
              hasMemoryEvents: memoryEvents.isNotEmpty,
            ),
            if (isExpanded && memoryEvents.isNotEmpty)
              MemoryEventGrid(
                memoryEvents: memoryEvents,
                onMemoryEventTap: (memoryEvent) {
                  // Navigate to full screen image view
                  showFullScreenImage(memoryEvent.imagePath);
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: controller.goToAddPerson,
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            controller.goToRecognition();
            break;
          case 2:
            controller.goToSettings();
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppStrings.home.tr),
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
}
