import 'package:get/get.dart';

import '../controllers/sell_entry_ticket_controller.dart';

class SellEntryTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellEntryTicketController>(
      () => SellEntryTicketController(),
    );
  }
}
