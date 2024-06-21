import 'package:get/get.dart';

import '../controllers/ride_ticket_controller.dart';

class RideTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideTicketController>(
      () => RideTicketController(),
    );
  }
}
