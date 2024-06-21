import 'package:get/get.dart';

import '../controllers/verified_ticket_controller.dart';

class VerifiedTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifiedTicketController>(
      () => VerifiedTicketController(),
    );
  }
}
