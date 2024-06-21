import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/commons/widgets/custom_input_field.dart';
import 'package:sohoz_park/app/commons/home/views/left_menu.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';
import 'dart:math' as math;
import '../../../utils/validator.dart';
import '../controllers/ride_ticket_controller.dart';

class RideTicketView extends GetView<RideTicketController> {
  const RideTicketView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: ColorManager.backgroundColor,
            key: controller.scaffoldKey,
            drawer: const LeftMenu(),
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
                "Sell Ride Ticket",
                style: getSemiBoldStyle(
                    fontSize: 22,
                    color: ColorManager.inputFieldTitleColor333333),
              ),
            ),
            body: Obx(() => CustomScrollView(
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.all(16),
                    ),
                    if (controller.zoneTicketItems.isNotEmpty == true)
                      SliverList.builder(
                        itemCount: controller.zoneTicketItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: controller.colors[index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: Get.width - 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (controller.zoneTicketItems[index]
                                                      .rides!.length >
                                                  1)
                                              ? Text(
                                                  '${controller.zoneTicketItems[index].name} (${controller.zoneTicketItems[index].rides!.length} Rides) ',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: getBoldStyle(
                                                      fontSize: 14,
                                                      color: ColorManager
                                                          .primaryWhite),
                                                )
                                              : Text(
                                                  '${controller.zoneTicketItems[index].name} ',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: getBoldStyle(
                                                      fontSize: 14,
                                                      color: ColorManager
                                                          .primaryWhite),
                                                ),
                                          Text(
                                            '(${controller.zoneTicketItems[index].category?.name ?? ''})',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: getBoldStyle(
                                                fontSize: 14,
                                                color:
                                                    ColorManager.primaryWhite),
                                          ),
                                          Text(
                                            'bdt ${controller.zoneTicketItems[index].price}'
                                                .toString(),
                                            style: getRegularStyle(
                                                fontSize: 14,
                                                color:
                                                    ColorManager.primaryWhite),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      width: 140,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                      child: Center(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: 4,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                controller
                                                    .decrementValue(index);

                                                controller
                                                    .getTotalTicketCounts();
                                                controller.getTotalPrice();
                                              },
                                              child: Container(
                                                  height: 24,
                                                  width: 24,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  child: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              child: CustomInputField(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  hintText: '0',
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        2),
                                                  ],
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                    decimal: false,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  height: 40,
                                                  controller: controller
                                                      .inputControllers[index],
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      controller
                                                              .zoneTicketItems[
                                                                  index]
                                                              .ticketCount =
                                                          int.tryParse(value) ??
                                                              0;
                                                      controller.zoneTicketItems
                                                          .refresh();

                                                      controller
                                                          .getTotalTicketCounts();
                                                      controller
                                                          .getTotalPrice();
                                                    } else {
                                                      controller
                                                          .zoneTicketItems[
                                                              index]
                                                          .ticketCount = 0;
                                                      controller
                                                          .getTotalTicketCounts();
                                                      controller
                                                          .getTotalPrice();
                                                    }
                                                  },
                                                  isEnabled: true),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                controller
                                                    .incrementValue(index);

                                                controller
                                                    .getTotalTicketCounts();
                                                controller.getTotalPrice();
                                              },
                                              child: Container(
                                                  height: 24,
                                                  width: 24,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 16),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mobile Number',
                                  style: getMediumStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333)),
                              if (controller.isScanning.value == true)
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Get.width / 2,
                                        width: Get.width / 2,
                                        child: QRView(
                                          key: controller.qrKey,
                                          overlay: QrScannerOverlayShape(
                                            borderColor: Colors.red,
                                            // borderRadius: 10,
                                            // borderLength: 30,
                                            // borderWidth: 10,
                                          ),
                                          onQRViewCreated:
                                              (QRViewController cltr) {
                                            controller.qrViewController = cltr;
                                            cltr.scannedDataStream
                                                .listen((event) {
                                              if (event.code!.isNotEmpty) {
                                                String result = event.code!;
                                                var json = jsonDecode(result);
                                                print(result);
                                                print(json['phone']);
                                                var mobileNumber =
                                                    json['phone'].toString();

                                                if (mobileNumber != null) {
                                                  controller.qrViewController
                                                      ?.pauseCamera();
                                                  controller.mobileNumberCtlr
                                                      .text = mobileNumber;
                                                  controller
                                                      .changeScanningFlage();
                                                } else {
                                                  controller.qrViewController
                                                      ?.pauseCamera();
                                                  controller
                                                      .changeScanningFlage();
                                                  AppConfigs.showToast(
                                                      "Invalid Qr!",
                                                      Colors.red);
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            controller.qrViewController
                                                ?.toggleFlash();
                                          },
                                          child: Text('Flash On/Off'))
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 8),
                              CustomInputField(
                                controller: controller.mobileNumberCtlr,
                                isEnabled: true,
                                hintText: 'Enter Mobile Number',
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.changeScanningFlage();
                                  },
                                  child: Icon(Icons.qr_code),
                                ),
                                keyboardType: TextInputType.number,
                                backgroundColor: ColorManager.primaryWhite,
                                validator: (value) =>
                                    MyCustomValidator.validateMobileNumber(
                                        value, context),
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                              CustomButton(
                                buttonTitle: 'Confirm Tickets',
                                onPressed: () {
                                  if (controller.totalTicketCounter.value ==
                                      0) {
                                    AppConfigs.showToast(
                                        'You have not added any ticket. You have to input at least one ticket to proceed.',
                                        Colors.red);
                                  } else if (controller
                                          .totalTicketCounter.value >
                                      10) {
                                    AppConfigs.showToast(
                                        'You can buy maximum 10 tickets at a time!',
                                        Colors.red);
                                  } else {
                                    // if (controller.formKey.currentState!
                                    //     .validate()) {
                                    //   showConfirmationPopUp();
                                    // }
                                    if (controller
                                            .mobileNumberCtlr.text.isEmpty ==
                                        true) {
                                      showConfirmationPopUp();
                                    } else {
                                      if (controller
                                              .mobileNumberCtlr.text.length ==
                                          11) {
                                        showConfirmationPopUp();
                                      } else {
                                        AppConfigs.showToast(
                                            'Enter a valid mobile number!',
                                            Colors.red);
                                      }
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  void showConfirmationPopUp() {
    Get.defaultDialog(
        title: "Are you sure about selling it?",
        backgroundColor: ColorManager.primaryWhite,
        titleStyle: getSemiBoldStyle(
            fontSize: 22, color: ColorManager.inputFieldTitleColor333333),
        content: Container(
          decoration: BoxDecoration(
              color: ColorManager.primaryWhite,
              borderRadius: BorderRadius.circular(8)),
          height: (controller.zoneTicketItems.isNotEmpty == true)
              ? Get.height - 190
              // controller.zoneTicketItems
              //                 .length *
              //             90 +
              //         100
              : Get.height / 2.5,
          width: Get.width - 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    // color: ColorManager.grayE4E4E4,
                    // borderRadius:
                    // BorderRadius.circular(8),
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 8, right: 8, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket Type',
                        style: getRegularStyle(
                            fontSize: 12, color: ColorManager.textColor999999),
                      ),
                      Text(
                        'Money',
                        style: getRegularStyle(
                            fontSize: 12, color: ColorManager.textColor999999),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics:
                  //     const NeverScrollableScrollPhysics(),
                  itemCount: controller.zoneTicketItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (controller.zoneTicketItems[index].ticketCount == 0)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width / 2 - 24,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: controller
                                                    .zoneTicketItems[index]
                                                    .name,
                                                style: getSemiBoldStyle(
                                                    fontSize: 16,
                                                    color: ColorManager
                                                        .inputFieldTitleColor333333)),
                                            TextSpan(
                                                text: ' x ',
                                                style: getSemiBoldStyle(
                                                    fontSize: 18,
                                                    color: ColorManager
                                                        .inputFieldTitleColor333333)),
                                            TextSpan(
                                                text: controller
                                                    .zoneTicketItems[index]
                                                    .ticketCount
                                                    .toString(),
                                                style: getSemiBoldStyle(
                                                    fontSize: 16,
                                                    color: ColorManager
                                                        .inputFieldTitleColor333333)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                          '(${controller.zoneTicketItems[index].category?.name ?? ''})',
                                          style: getSemiBoldStyle(
                                              fontSize: 16,
                                              color: ColorManager
                                                  .inputFieldTitleColor333333)),
                                    ],
                                  ),
                                ),
                                Text(
                                    '৳  ${controller.zoneTicketItems[index].ticketCount * double.parse(controller.zoneTicketItems[index].price.toString()!)}',
                                    textAlign: TextAlign.right,
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333)),
                              ],
                            ),
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 0.0, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total   x ${controller.totalTicketCounter.value}',
                        style: getSemiBoldStyle(
                            fontSize: 16,
                            color: ColorManager.inputFieldTitleColor333333)),
                    Text('৳ ${controller.totalPrice.value}',
                        style: getSemiBoldStyle(
                            fontSize: 16,
                            color: ColorManager.inputFieldTitleColor333333)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                        buttonTitle: 'Yes',
                        width: 110,
                        onPressed: () {
                          if (controller.totalTicketCounter.value > 0) {
                            controller.buyRideTicket();
                          }
                        }),
                    CustomButton(
                        buttonTitle: 'Cancel',
                        border: Border.all(color: ColorManager.gray707070),
                        width: 110,
                        color: Colors.white,
                        textStyle: TextStyle(color: ColorManager.gray707070),
                        onPressed: () {
                          Get.back();
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
