import 'package:get/get.dart';

import '../controllers/all_presesensi_controller.dart';

class AllPresesensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPresesensiController>(
      () => AllPresesensiController(),
    );
  }
}
