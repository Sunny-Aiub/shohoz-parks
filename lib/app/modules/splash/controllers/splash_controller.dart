import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';

class SplashController extends GetxController {
  RxDouble progressValue = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    updateProgress();
  }

  void updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      progressValue.value += 0.50;
      update();

      if (progressValue.value.toStringAsFixed(1) == "1.0") {
        t.cancel();

        if (GetStorage().read('isLoggedIn')) {
//          Get.offAndToNamed(Routes.HOME);
          Get.offAndToNamed(Routes.LOGIN);

        } else {
          Get.offAndToNamed(Routes.LOGIN);
        }
      } else {
        if (kDebugMode) {
          print(progressValue.value);
        }
      }
    });
  }
}
