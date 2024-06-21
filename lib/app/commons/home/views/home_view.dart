// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/commons/widgets/custom_input_field.dart';
import 'package:sohoz_park/app/commons/home/views/left_menu.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Colors.white, Color(0xFFFEFBEA)],
          ),
        ),
        child: PopScope(
          canPop: false,
          child: Scaffold(
            key: controller.scaffoldKey,
            drawer: LeftMenu(),
            appBar: AppBar(
              centerTitle: false,
              elevation: 0.0,
              leading: InkWell(
                onTap: controller.openDrawer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(AssetConstant.leftMenuIcon),
                ),
              ),
              title: Text(
                "Home",
                style: getSemiBoldStyle(
                    fontSize: 22,
                    color: ColorManager.inputFieldTitleColor333333),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Image.asset(
                      AssetConstant.homeImage,
                      fit: BoxFit.cover,
                      height: 320,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                              width: Get.width / 2 - 20,
                              height: 74,
                              textAlign: TextAlign.center,
                              buttonTitle: 'Sell Entry Ticket',
                              textStyle: getBoldStyle(
                                  fontSize: 16, color: ColorManager.primaryWhite),
                              onPressed: () {
                                if (AppConfigs.isEntryTicketSeller == true) {
                                  Get.toNamed(Routes.SELL_ENTRY_TICKET);
                                } else {
                                  AppConfigs.showToast(
                                      "You don't have permission for this",
                                      Colors.red);
                                }
                              }),

                          CustomButton(
                              width: Get.width / 2 - 20,
                              height: 74,
                              buttonTitle: 'Sell Package Ticket',
                              textStyle: getSemiBoldStyle(
                                  fontSize: 16,
                                  color: ColorManager.primaryWhite),
                              onPressed: () {
                                if (AppConfigs.isEntryTicketSeller == true) {
                                  Get.offAndToNamed(Routes.PACKAGE);
                                } else {
                                  AppConfigs.showToast(
                                      "You don't have permission for this",
                                      Colors.red);
                                }
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                              height: 74,
                              width: Get.width / 2 - 20,
                              buttonTitle: 'Sell Ride Ticket',
                              textStyle: getSemiBoldStyle(
                                  fontSize: 16,
                                  color: ColorManager.primaryWhite),
                              onPressed: () {
                                if (AppConfigs.isZoneTicketSeller == true) {
                                  Get.offAndToNamed(Routes.RIDE_TICKET);
                                } else {
                                  AppConfigs.showToast(
                                      "You don't have permission for this",
                                      Colors.red);
                                }
                              }),
                          CustomButton(
                              height: 74,
                              width: Get.width / 2 - 20,
                              buttonTitle: 'Scan Ticket',
                              textStyle: getSemiBoldStyle(
                                  fontSize: 16,
                                  color: ColorManager.primaryWhite),
                              // onPressed: () => Get.offAndToNamed(Routes.SCAN),
                              onPressed: () {
                                if (AppConfigs.isTicketScanner == true) {
                                  Get.offAndToNamed(Routes.SCAN);
                                } else {
                                  AppConfigs.showToast(
                                      "You don't have permission for this",
                                      Colors.red);
                                }
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
