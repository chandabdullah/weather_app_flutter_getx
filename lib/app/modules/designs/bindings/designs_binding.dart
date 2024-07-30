import 'package:get/get.dart';

import '../controllers/designs_controller.dart';

class DesignsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DesignsController>(
      () => DesignsController(),
    );
  }
}
