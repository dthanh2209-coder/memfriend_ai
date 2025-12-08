import 'package:get/get.dart';

import '../../../core/ai/vi_face_core.dart';
import '../../../core/values/app_strings.dart';
import '../../../data/models/face.dart';
import '../../../data/models/memory_event.dart';
import '../../../data/models/person.dart';
import '../../../data/providers/database_helper.dart';
import '../../../data/services/storage_service.dart';

class HomeController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();

  // Observables
  final RxList<Person> persons = <Person>[].obs;
  final RxList<Person> filteredPersons = <Person>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;
  final RxMap<int, Face?> latestFaces = <int, Face?>{}.obs;
  final RxMap<int, List<MemoryEvent>> memoryEvents =
      <int, List<MemoryEvent>>{}.obs;
  final RxMap<int, bool> expandedPersons = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadPersons();
  }

  /// Load all persons from database
  Future<void> loadPersons() async {
    try {
      isLoading.value = true;
      final personList = await _databaseHelper.getAllPersons();
      persons.value = personList;
      filteredPersons.value = personList;

      // Load latest faces for each person
      for (final person in personList) {
        if (person.id != null) {
          final latestFace = await _databaseHelper.getLatestFaceByPersonId(
            person.id!,
          );
          latestFaces[person.id!] = latestFace;

          // Load memory events for each person
          final events = await _databaseHelper.getMemoryEventsByPersonId(
            person.id!,
          );
          memoryEvents[person.id!] = events;
        }
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        '${AppStrings.failedToLoadPersons.tr}: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Search persons by name, phone, or relation
  void searchPersons(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPersons.value = persons;
    } else {
      filteredPersons.value = persons.where((person) {
        return person.name.toLowerCase().contains(query.toLowerCase()) ||
            (person.phone?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (person.relation?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }
  }

  /// Toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      clearSearch();
    }
  }

  // Close search
  void closeSearch() {
    isSearching.value = false;
    clearSearch();
  }

  /// Clear search and show all persons
  void clearSearch() {
    isSearching.value = false;
    searchQuery.value = '';
    filteredPersons.value = persons;
  }

  /// Navigate to person detail screen
  void goToPersonDetail(Person person) {
    clearSearch();
    Get.toNamed('/person-detail', arguments: person)?.then((_) => loadPersons());
  }

  /// Navigate to add person screen
  Future<void> goToAddPerson() async {
    closeSearch();
    Get.toNamed('/add-person')?.then((_) => loadPersons());
  }

  /// Navigate to recognition screen
  void goToRecognition() {
    closeSearch();
    Get.offAllNamed('/recognition');
  }

  /// Navigate to settings screen
  void goToSettings() {
    closeSearch();
    Get.offAllNamed('/settings');
  }

  /// Delete person with confirmation
  Future<void> deletePerson(Person person) async {
    if (person.id == null) return;

    final confirmed = await Get.defaultDialog(
      title: AppStrings.confirmDeleteTitle.tr,
      middleText: AppStrings.confirmDeletePerson.tr,
      textConfirm: AppStrings.delete.tr,
      textCancel: AppStrings.cancel.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      try {
        isLoading.value = true;

        // Get all faces and memory events before deletion
        final personFaces = await _databaseHelper.getFacesByPersonId(
          person.id!,
        );
        final personMemoryEvents = await _databaseHelper
            .getMemoryEventsByPersonId(person.id!);

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
        await _databaseHelper.deletePerson(person.id!);

        // Rebuild vector data after face deletion
        ViFaceCore.buildVectorData();

        // Update UI state
        persons.removeWhere((p) => p.id == person.id);
        filteredPersons.removeWhere((p) => p.id == person.id);
        latestFaces.remove(person.id!);
        memoryEvents.remove(person.id!);
        expandedPersons.remove(person.id!);

        Get.snackbar(
          AppStrings.success.tr,
          AppStrings.personDeleted.tr,
          backgroundColor: Get.theme.colorScheme.tertiary,
          colorText: Get.theme.colorScheme.onTertiary,
          isDismissible: true,
        );
      } catch (e) {
        Get.snackbar(
          AppStrings.error.tr,
          '${AppStrings.failedToDeletePerson.tr}: $e',
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Toggle person expansion for memory events
  void togglePersonExpansion(int personId) {
    expandedPersons[personId] = !(expandedPersons[personId] ?? false);
  }

  /// Check if person is expanded
  bool isPersonExpanded(int personId) {
    return expandedPersons[personId] ?? false;
  }

  /// Get latest face for person
  Face? getLatestFace(int personId) {
    return latestFaces[personId];
  }

  /// Get memory events for person
  List<MemoryEvent> getMemoryEvents(int personId) {
    return memoryEvents[personId] ?? [];
  }

  /// Refresh data
  @override
  Future<void> refresh() async {
    await loadPersons();
  }
}
