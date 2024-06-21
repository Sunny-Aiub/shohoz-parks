import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sohoz_park/app/http/request.dart';
import 'package:sohoz_park/app/modules/login/models/login_response.dart';
import 'package:sohoz_park/app/modules/scan/data/ride_scan_response.dart';

import '../../../commons/colors.dart';
import '../../../commons/styles.dart';
import '../../../commons/widgets/custom_button.dart';
import '../../../http/url.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/appconfigs.dart';
import '../data/entry_scan_response.dart';
import '../data/single_ride_scan_response.dart';

class ScanController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;

  var isScanning = false.obs;
  final GetStorage storage = GetStorage();
  var totalTicketCounter = 0.obs;
  var totalPrice = 0.obs;

  Ride? selectedRide;
  void openDrawer() {
    print('open');
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  void changeScanningFlage() {
    isScanning.value = !isScanning.value;
    update();
    refresh();
  }

  scanEntryTicketApi(String phone, String type, int ticketID) {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + '/ticket/entry/scan', body: {
          "phone": phone,
          "id": ticketID,
        }, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();

          print(response.statusCode);
          print(response.body);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();

            if (type == "entry") {
              EntryScanResponse model =
                  EntryScanResponse.fromJson(jsonDecode(response.body));

              if (model.data == null) {
                AppConfigs.showToast("Invalid Ticket!", Colors.red);
              } else {
                Get.defaultDialog(
                    title: "Entry Ticket Verified !",
                    backgroundColor: Colors.white,
                    titleStyle: getSemiBoldStyle(
                        fontSize: 22,
                        color: ColorManager.inputFieldTitleColor333333),
                    content: Container(
                      decoration: BoxDecoration(
                          color: ColorManager.primaryWhite,
                          borderRadius: BorderRadius.circular(8)),
                      // height: Get.height / 2,
                      width: Get.width - 32,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16, right: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Mobile No: ',
                                  style: getSemiBoldStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333),
                                ),
                                Text(
                                  model.data?.phone ?? '',
                                  style: getSemiBoldStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16, right: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ticket Type',
                                  style: getRegularStyle(
                                      fontSize: 12,
                                      color: ColorManager.textColor999999),
                                ),
                                Text(
                                  'Money',
                                  style: getRegularStyle(
                                      fontSize: 12,
                                      color: ColorManager.textColor999999),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child:

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text.rich(
                            TextSpan(
                            children: [
                                TextSpan(
                                text: model.data?.ticket?.name ?? '',
                                style: getSemiBoldStyle(
                                    fontSize: 16,
                                    color: ColorManager
                                        .inputFieldTitleColor333333)),
                            TextSpan(
                                text: 'x',
                                style: getSemiBoldStyle(
                                    fontSize: 18,
                                    color: ColorManager
                                        .inputFieldTitleColor333333)),
                            TextSpan(
                                text: 1.toString(),
                                style: getSemiBoldStyle(
                                    fontSize: 16,
                                    color: ColorManager
                                        .inputFieldTitleColor333333)),
                            ],
                          ),
                ),
                                Text(
                                    '৳  ${model.data!.amount.toString()}',
                                    textAlign: TextAlign.right,
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333))
                              ],
                            ),

                          ),
                           Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 24, top: 0.0, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Total   x 1', //${totalTicketCounter.value}',
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333)),
                                Text(
                                    '৳ ${model.data!.amount.toString()}', //${totalPrice.value}',
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333)),
                              ],
                            ),
                          ),
                          if (model.data?.redeem.toString() == "1")
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${model.message}', //${totalPrice.value}',
                                      style: getSemiBoldStyle(
                                          fontSize: 16,
                                          color: ColorManager.primaryWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                          if (model.data?.status.toString() == "0")
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Ticket Cancelled!', //${totalPrice.value}',
                                      style: getSemiBoldStyle(
                                          fontSize: 16,
                                          color: ColorManager.primaryWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (model.data?.redeem.toString() == "0" && model.data?.status.toString() == "1" )
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                  width: Get.width - 32,
                                  buttonTitle: 'Redeem',
                                  onPressed: () {
                                    redeemTicket(phone, ticketID, type);
                                  }),
                            ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                                width: Get.width - 32,
                                buttonTitle: 'Back',
                                color: Colors.grey,
                                onPressed: () {
                                  Get.back();
                                }),
                          ),
                        ],
                      ),
                    ));
              }
            } else if (type == "zone") {
            } else {
              print('Unknown Type');
            }
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();

            Get.offAllNamed(Routes.LOGIN);
            AppConfigs.showToast(
                "You are not authorised for this!", Colors.red);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            AppConfigs.showToast("Invalid Ticket!", Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast("Invalid QR Code!", Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          print('Error: $e');
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: $e', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  redeemTicket(String phoneNumber, int ticketID, String type) {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: '$BASE_URL/ticket/$type/redeem', body: {
          "phone": phoneNumber,
          "id": ticketID,
          "ride": type == 'entry' ? null : selectedRide!.id

        }, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        });

        print(request.body);
        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();
          print(response.body);

          print(response.statusCode);
          print(response.body);

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            Get.back();

            update();
            AppConfigs.showToast("Ticket Redeemed", Colors.green);
          } else if (response.statusCode == 302) {
            EasyLoading.dismiss();
            Get.back();

            update();
            AppConfigs.showToast("Already Redeemed", Colors.red);
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                'Session Expired. Please login again!', Colors.red);
            Get.offAllNamed(Routes.LOGIN);
          } else if (response.statusCode == 406) {
            var json = jsonDecode(response.body);

            EasyLoading.dismiss();
            AppConfigs.showToast(json["message"], Colors.red);
            Get.offAllNamed(Routes.LOGIN);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            AppConfigs.showToast(AppConfigs.SOMETHING_WENT_WRONG, Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast(AppConfigs.SOMETHING_WENT_WRONG, Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          print('Error: $e');
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: $e', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  scanRideTicketApi(String phone, String type, int ticketID) {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + '/ticket/ride/scan', body: {
          "phone": phone,
          "id": ticketID,
          "ride": selectedRide!.id

        }, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();

          print(response.statusCode);
          print(response.body);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();

            if (type == "entry") {
            } else if (type == "zone") {
              RideSingleScanResponse model =
                  RideSingleScanResponse.fromJson(jsonDecode(response.body));

              if (model.data == null) {
                AppConfigs.showToast("Invalid Ticket!", Colors.red);
              } else {
                Get.defaultDialog(
                    title: "Ride Ticket Verified !",
                    backgroundColor: Colors.white,
                    titleStyle: getSemiBoldStyle(
                        fontSize: 22,
                        color: ColorManager.inputFieldTitleColor333333),
                    content: Container(
                      decoration: BoxDecoration(
                          color: ColorManager.primaryWhite,
                          borderRadius: BorderRadius.circular(8)),
                      // height: Get.height / 2,
                      width: Get.width - 32,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16, right: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Mobile No: ',
                                  style: getSemiBoldStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333),
                                ),
                                Text(
                                  model.data?.phone ?? '',
                                  style: getSemiBoldStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16, right: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ticket Type',
                                  style: getRegularStyle(
                                      fontSize: 12,
                                      color: ColorManager.textColor999999),
                                ),
                                Text(
                                  'Money',
                                  style: getRegularStyle(
                                      fontSize: 12,
                                      color: ColorManager.textColor999999),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      '${model.data?.ride?.name ?? ''} (${model.data?.ticket?.name ?? ''})',
                                      style: getSemiBoldStyle(
                                          fontSize: 16,
                                          color: ColorManager
                                              .inputFieldTitleColor333333)),
                                ),


                                                      Text(
                              '৳  ${model.data!.amount.toString()}',
                              textAlign: TextAlign.right,
                              style: getSemiBoldStyle(
                                  fontSize: 16,
                                  color: ColorManager
                                      .inputFieldTitleColor333333)),
                            ]
                                                       ),),
                           Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 24, top: 0.0, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Total   x 1', //${totalTicketCounter.value}',
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333)),
                                Text(
                                    '৳ ${model.data!.amount.toString()}', //${totalPrice.value}',
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333)),
                              ],
                            ),
                          ),
                          if (model.data?.redeem.toString() == "1")
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${model.message}', //${totalPrice.value}',
                                      style: getSemiBoldStyle(
                                          fontSize: 16,
                                          color: ColorManager.primaryWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (model.data?.redeem.toString() == "0")
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                  width: Get.width - 32,
                                  buttonTitle: 'Redeem',
                                  onPressed: () {
                                    redeemTicket(phone, ticketID, 'ride');
                                  }),
                            ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                                width: Get.width - 32,
                                buttonTitle: 'Back',
                                color: Colors.grey,
                                onPressed: () {
                                  Get.back();
                                }),
                          ),

                        ],
                      ),
                    ));
              }
            } else {
              print('Unknown Type');
            }
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();

            Get.offAllNamed(Routes.LOGIN);
            AppConfigs.showToast(
                "You are not authorised for this!", Colors.red);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            AppConfigs.showToast("Check your Inputs correctly", Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast("Check your Inputs correctly", Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          print('Error: $e');
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: $e', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  void setRideValue(Ride ride) {
     selectedRide  = ride;
     update();
  }
}
