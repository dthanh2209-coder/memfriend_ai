import 'package:get/get.dart';
import '../controllers/add_memory_controller.dart';

class AddMemoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMemoryController>(
      () => AddMemoryController(),
    );
  }
}
