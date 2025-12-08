import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/person_detail/bindings/person_detail_binding.dart';
import '../modules/person_detail/views/person_detail_view.dart';
import '../modules/recognition/bindings/recognition_binding.dart';
import '../modules/recognition/views/recognition_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/add_person/bindings/add_person_binding.dart';
import '../modules/add_person/views/add_person_view.dart';
import '../modules/add_face/bindings/add_face_binding.dart';
import '../modules/add_face/views/add_face_view.dart';
import '../modules/add_memory/bindings/add_memory_binding.dart';
import '../modules/add_memory/views/add_memory_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.personDetail,
      page: () => const PersonDetailView(),
      binding: PersonDetailBinding(),
    ),
    GetPage(
      name: _Paths.recognition,
      page: () => const RecognitionView(),
      binding: RecognitionBinding(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.addPerson,
      page: () => const AddPersonView(),
      binding: AddPersonBinding(),
    ),
    GetPage(
      name: _Paths.editPerson,
      page: () => const AddPersonView(),
      binding: AddPersonBinding(),
    ),
    GetPage(
      name: _Paths.addFace,
      page: () => const AddFaceView(),
      binding: AddFaceBinding(),
    ),
    GetPage(
      name: _Paths.addMemory,
      page: () => const AddMemoryView(),
      binding: AddMemoryBinding(),
    ),
    GetPage(
      name: _Paths.editMemory,
      page: () => const AddMemoryView(),
      binding: AddMemoryBinding(),
    ),
  ];
}
