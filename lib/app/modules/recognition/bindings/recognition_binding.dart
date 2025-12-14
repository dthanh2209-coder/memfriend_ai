import 'package:get/get.dart';
import '../controllers/recognition_controller.dart';

class RecognitionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecognitionController>(
      () => RecognitionController(),
    );
  }
}
