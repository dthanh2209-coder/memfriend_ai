import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_friend/app/core/ai/vi_face_core.dart';

import '../../../core/values/app_strings.dart';
import '../../../data/models/face.dart';
import '../../../data/models/memory_event.dart';
import '../../../data/models/person.dart';
import '../../../data/providers/database_helper.dart';
import '../../../data/services/storage_service.dart';

class PersonDetailController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();

  // Person data
  final Rx<Person?> person = Rx<Person?>(null);
  final RxList<Face> faces = <Face>[].obs;
  final RxList<MemoryEvent> memoryEvents = <MemoryEvent>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingFaces = false.obs;
  final RxBool isLoadingMemoryEvents = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPersonData();
  }

  void _loadPersonData() {
    final arguments = Get.arguments;
    if (arguments is Person) {
      person.value = arguments;
      _loadPersonDetails();
    } else {
      Get.back();
      Get.snackbar('Error', 'Invalid person data');
    }
  }

  Future<void> _loadPersonDetails() async {
    if (person.value?.id == null) return;

    try {
      isLoading.value = true;

      // Load faces and memory events in parallel
      await Future.wait([_loadFaces(), _loadMemoryEvents()]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load person details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFaces() async {
    if (person.value?.id == null) return;

    try {
      isLoadingFaces.value = true;
      final faceList = await _databaseHelper.getFacesByPersonId(
        person.value!.id!,
      );
      faces.value = faceList;
    } catch (e) {
      print('Error loading faces: $e');
    } finally {
      isLoadingFaces.value = false;
    }
  }

  Future<void> _loadMemoryEvents() async {
    if (person.value?.id == null) return;

    try {
      isLoadingMemoryEvents.value = true;
      final eventList = await _databaseHelper.getMemoryEventsByPersonId(
        person.value!.id!,
      );
      memoryEvents.value = eventList;
    } catch (e) {
      print('Error loading memory events: $e');
    } finally {
      isLoadingMemoryEvents.value = false;
    }
  }

  /// Show person actions menu
  void showPersonActionsMenu() {
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
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(AppStrings.editPerson.tr),
                onTap: () {
                  Get.back();
                  editPerson();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(AppStrings.deletePerson.tr),
                onTap: () {
                  Get.back();
                  deletePerson();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Edit person
  void editPerson() {
    Get.toNamed('/edit-person', arguments: person.value)?.then((result) {
      if (result == true) {
        // Reload person data
        _reloadPersonData();
      }
    });
  }

  /// Delete person with confirmation
  Future<void> deletePerson() async {
    final confirmed = await Get.defaultDialog(
      title: AppStrings.confirmDeleteTitle.tr,
      middleText: AppStrings.confirmDeletePerson,
      textConfirm: AppStrings.delete.tr,
      textCancel: AppStrings.cancel.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );
    if (confirmed == true && person.value?.id != null) {
      try {
        isLoading.value = true;

        // Get all faces and memory events before deletion
        final personFaces = await _databaseHelper.getFacesByPersonId(
          person.value!.id!,
        );
        final personMemoryEvents = await _databaseHelper
            .getMemoryEventsByPersonId(person.value!.id!);

        // Delete all face image files
        for (final face in personFaces) {
          try {
            await _storageService.deleteFile(face.path);
          } catch (e) {
            print('Error deleting face file ${face.path}: $e');
          }
        }

        // Delete all memory event image files
        for (final memoryEvent in personMemoryEvents) {
          try {
            await _storageService.deleteFile(memoryEvent.imagePath);
          } catch (e) {
            print(
              'Error deleting memory event file ${memoryEvent.imagePath}: $e',
            );
          }
        }

        // Delete person from database (this will cascade delete faces and memory events)
        await _databaseHelper.deletePerson(person.value!.id!);

        // Rebuild vector data after face deletion
        ViFaceCore.buildVectorData();

        Get.back(result: true); // Go back to previous screen
        Get.snackbar('Success', AppStrings.personDeleted);
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete person: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Navigate to add face screen
  void goToAddFace() {
    Get.toNamed('/add-face', arguments: person.value)?.then((result) {
      if (result == true) {
        _loadFaces();
      }
    });
  }

  /// Delete face with confirmation
  Future<void> deleteFace(Face face) async {
    final confirmed = await Get.defaultDialog(
      title: AppStrings.confirmDeleteTitle.tr,
      middleText: AppStrings.confirmDeleteFace.tr,
      textConfirm: AppStrings.delete.tr,
      textCancel: AppStrings.cancel.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true && face.id != null) {
      try {
        // Delete from database
        await _databaseHelper.deleteFace(face.id!);

        // Delete file
        await _storageService.deleteFile(face.path);

        // Remove from list
        faces.removeWhere((f) => f.id == face.id);

        // build vector data
        ViFaceCore.buildVectorData();

        Get.snackbar('Success', AppStrings.faceDeleted.tr);
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete face: $e');
      }
    }
  }

  /// Navigate to add memory event screen
  void goToAddMemoryEvent() {
    Get.toNamed('/add-memory', arguments: person.value)?.then((result) {
      if (result == true) {
        _loadMemoryEvents();
      }
    });
  }

  /// Show memory event actions menu
  void showMemoryEventActions(MemoryEvent memoryEvent) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title:  Text(AppStrings.editMemoryEvent.tr),
              onTap: () {
                Get.back();
                editMemoryEvent(memoryEvent);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title:  Text(AppStrings.deleteMemoryEvent.tr),
              onTap: () {
                Get.back();
                deleteMemoryEvent(memoryEvent);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Edit memory event
  void editMemoryEvent(MemoryEvent memoryEvent) {
    Get.toNamed(
      '/edit-memory',
      arguments: {'person': person.value, 'memoryEvent': memoryEvent},
    )?.then((result) {
      if (result == true) {
        _loadMemoryEvents();
      }
    });
  }

  /// Delete memory event with confirmation
  Future<void> deleteMemoryEvent(MemoryEvent memoryEvent) async {
    final confirmed = await Get.defaultDialog(
      title: AppStrings.confirmDeleteTitle.tr,
      middleText: AppStrings.confirmDeleteMemoryEvent.tr,
      textConfirm: AppStrings.delete.tr,
      textCancel: AppStrings.cancel.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true && memoryEvent.id != null) {
      try {
        // Delete from database
        await _databaseHelper.deleteMemoryEvent(memoryEvent.id!);

        // Delete file
        await _storageService.deleteFile(memoryEvent.imagePath);

        // Remove from list
        memoryEvents.removeWhere((e) => e.id == memoryEvent.id);

        Get.snackbar(
          'Success',
          AppStrings.memoryEventDeleted.tr,
          backgroundColor: Get.theme.colorScheme.tertiary,
          colorText: Get.theme.colorScheme.onTertiary,
          isDismissible: true,
        );
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete memory event: $e');
      }
    }
  }

  /// Reload person data from database
  Future<void> _reloadPersonData() async {
    if (person.value?.id == null) return;

    try {
      final updatedPerson = await _databaseHelper.getPersonById(
        person.value!.id!,
      );
      if (updatedPerson != null) {
        person.value = updatedPerson;
      }
      await _loadPersonDetails();
    } catch (e) {
      print('Error reloading person data: $e');
    }
  }

  /// Refresh all data
  @override
  Future<void> refresh() async {
    await _reloadPersonData();
  }

  /// Get latest face for avatar
  Face? get latestFace {
    if (faces.isEmpty) return null;
    return faces.first; // faces are already sorted by updated_time DESC
  }
}
