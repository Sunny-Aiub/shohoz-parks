import 'package:get/get.dart';

import '../modules/changePassword/bindings/change_password_binding.dart';
import '../modules/changePassword/views/change_password_view.dart';
import '../commons/home/bindings/home_binding.dart';
import '../commons/home/bindings/home_binding.dart';
import '../commons/home/views/home_view.dart';
import '../commons/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/package/bindings/package_binding.dart';
import '../modules/package/views/package_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/rideTicket/bindings/ride_ticket_binding.dart';
import '../modules/rideTicket/views/ride_ticket_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/sellEntryTicket/bindings/sell_entry_ticket_binding.dart';
import '../modules/sellEntryTicket/views/sell_entry_ticket_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/verifiedTicket/bindings/verified_ticket_binding.dart';
import '../modules/verifiedTicket/views/verified_ticket_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SELL_ENTRY_TICKET,
      page: () => const SellEntryTicketView(),
      binding: SellEntryTicketBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_TICKET,
      page: () => const RideTicketView(),
      binding: RideTicketBinding(),
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.VERIFIED_TICKET,
      page: () => const VerifiedTicketView(),
      binding: VerifiedTicketBinding(),
    ),
    GetPage(
      name: _Paths.PACKAGE,
      page: () => const PackageView(),
      binding: PackageBinding(),
    ),
  ];
}
