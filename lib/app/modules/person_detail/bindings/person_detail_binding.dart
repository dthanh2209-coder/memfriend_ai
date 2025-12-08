import 'package:get/get.dart';
import '../controllers/person_detail_controller.dart';

class PersonDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonDetailController>(
      () => PersonDetailController(),
    );
  }
}
