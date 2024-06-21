import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
            body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFFFFFEAC), Color(0xFFFEFBEA)],
            ),
          ),
          child: Stack(
             alignment: Alignment.center,
            children: [
              SvgPicture.asset(AssetConstant.sohozLogoIcon),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorManager.primaryGreen),
                    value: controller.progressValue.value,
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
