import 'package:get/get.dart';
import '../controllers/add_face_controller.dart';

class AddFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFaceController>(
      () => AddFaceController(),
    );
  }
}
