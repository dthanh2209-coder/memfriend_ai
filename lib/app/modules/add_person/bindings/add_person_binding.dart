import 'package:get/get.dart';
import '../controllers/add_person_controller.dart';

class AddPersonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPersonController>(
      () => AddPersonController(),
    );
  }
}
