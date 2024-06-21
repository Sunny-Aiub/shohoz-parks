// ignore_for_file: unnecessary_overrides

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sohoz_park/app/data/sellEntryTicket/ticket.dart';
import 'package:sohoz_park/app/http/request.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'dart:math' as math;

import '../../../http/url.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/appconfigs.dart';
import '../models/ride_ticket_list_response.dart';
import '../models/ride_ticket_purchase.dart';

class RideTicketController extends GetxController {
  final zoneTicketItems = <ZoneTickets>[].obs;
  final inputControllers = <TextEditingController>[].obs;
  final colors = <Color>[].obs;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var mobileNumberCtlr = TextEditingController();
  final GetStorage storage = GetStorage();

  final formKey = GlobalKey<FormState>();
  var totalTicketCounter = 0.obs;
  var totalPrice = 0.0.obs;

  RxString platformVersion = 'Unknown'.obs;
  RxString statusPrinter = '0'.obs;
  bool isLoading = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;

  var isScanning = false.obs;
  void openDrawer() {
    if (kDebugMode) {
      print('open');
    }
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void onInit() {
    super.onInit();
    getTicketTypes();
    // initPlatformState();
    // getPrinterStatus();
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

// Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       platformVersion = await FlutterPaxPrinterUtility.platformVersion ??
//           'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//     this.platformVersion.value = platformVersion;
//     update();
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     // if (!mounted) return;
//     //
//     // setState(() {
//     //   platformVersion = platformVersion;
//     // });
//   }
//
//   getPrinterStatus() async {
//     await FlutterPaxPrinterUtility.init;
//     PrinterStatus status = await FlutterPaxPrinterUtility.getStatus;
//     print(status);
//     if (status == PrinterStatus.SUCCESS) {
//       statusPrinter.value = "1";
//     } else {
//       statusPrinter.value = "0";
//     }
//     update();
//     // setState(() {
//     //   if (status == PrinterStatus.SUCCESS) {
//     //     statusPrinter = "1";
//     //   } else {
//     //     statusPrinter = "0";
//     //   }
//     // });
//   }
//
//   printQrCode(Datum element) async {
//     var data = {"phone": element.phone, "id": element?.id, "type": "zone"};
//     await FlutterPaxPrinterUtility.fontSet(
//         EFontTypeAscii.FONT_32_48, EFontTypeExtCode.FONT_48_48);
//
//     await FlutterPaxPrinterUtility.spaceSet(0, 10);
//     await FlutterPaxPrinterUtility.setGray(1);
//     await FlutterPaxPrinterUtility.printQRReceipt(
//         'RIDE TICKET \n',
//         'MOBILE NO: ${element.phone ?? ''}\n',
//         "TYPE: ${element.ticket?.name ?? ''}\n",
//         "Amount: ${element.amount ?? ''}\n\DATE   : ${DateTime.now().toLocal()}\n",
//         jsonEncode(data));
//     await FlutterPaxPrinterUtility.spaceSet(0, 10);
//     await FlutterPaxPrinterUtility.printStr("\n", null);
//
//     await FlutterPaxPrinterUtility.printStr("    ** **  **  **  \n", null);
//
//     await FlutterPaxPrinterUtility.leftIndents(10);
//     await FlutterPaxPrinterUtility.printStr("\n\n", null);
//     await FlutterPaxPrinterUtility.printImageAsset(
//         "assets/images/logos-Photoroom.jpg");
//     await FlutterPaxPrinterUtility.printStr("\n\n\n\n", null);
//
//     ///printQRCode
//     // await FlutterPaxPrinterUtility.fontSet(
//     //     EFontTypeAscii.FONT_24_24, EFontTypeExtCode.FONT_24_24);
//     // await FlutterPaxPrinterUtility.spaceSet(0, 10);
//     // await FlutterPaxPrinterUtility.setGray(1);
//     // await FlutterPaxPrinterUtility.printStr('RIDE TICKET \n', null);
//     // await FlutterPaxPrinterUtility.printStr('\n\n', null);
//     // await FlutterPaxPrinterUtility.printStr(
//     //     'MOBILE NO: ${element.phone ?? ''}\n', null);
//     // await FlutterPaxPrinterUtility.printStr('\n', null);
//     // await FlutterPaxPrinterUtility.printStr(
//     //     'Amount: ${element.amount ?? ''}\n\DATE   : ${DateTime.now().toLocal()}\n',
//     //     null);
//     // await FlutterPaxPrinterUtility.printQRCode(jsonEncode(data), 512, 512);
//     //  await FlutterPaxPrinterUtility.step(150);
//   }

  getTicketTypes() {
    print('calling ride ticket types');
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request =
            Request(url: BASE_URL + API_RIDE_TICKET_TYPES, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.get();

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            RideTicketListResponse model =
                RideTicketListResponse.fromJson(jsonDecode(response.body));

            zoneTicketItems.value = model.data ?? [];
            update();
            zoneTicketItems.forEach((element) {
              inputControllers.add(TextEditingController());
              colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0));
            });
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                'Session Expired. Please login again!', Colors.red);
            Get.offAndToNamed(Routes.LOGIN);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            AppConfigs.showToast(AppConfigs.SOMETHING_WENT_WRONG, Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast("Check your Inputs correctly", Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          if (kDebugMode) {
            print('Error: $e');
          }
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: $e', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  void getTotalTicketCounts() {
    totalTicketCounter.value = 0;
    update();
    zoneTicketItems.forEach((element) {
      totalTicketCounter.value = totalTicketCounter.value + element.ticketCount;
      update();
    });
  }

  void getTotalPrice() {
    totalPrice.value = 0;
    update();
    zoneTicketItems.forEach((element) {
      totalPrice.value = totalPrice.value +
          (double.parse(element.price.toString()!) * element.ticketCount);
      update();
    });
  }

  void buyRideTicket() {
    print('buying entry ticket ');

    var tickets = [];
    zoneTicketItems.forEach((element) {
      if (element.ticketCount > 0) {
        tickets.add(
          {
            "id": int.parse(element.id.toString()),
            "quantity": element.ticketCount
          },
        );
      }
    });
    update();

    print(tickets);
    print(tickets.length);
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + API_RIDE_TICKET_BUY, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        }, body: {
          "phone": mobileNumberCtlr.text.isEmpty == true
              ? "01710000000"
              : mobileNumberCtlr.text,
          "tickets": tickets,
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();
          print(response.body);
          if (response.statusCode == 201) {
            EasyLoading.dismiss();
            RideTicketPurchaseResponse model =
                RideTicketPurchaseResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast("Ticket Sold!", Colors.green);

            update();
            if (model.data != null) {
              for (Datum element in model.data!) {
                // await printQrCode(element);
                var data = {
                  "phone": element.phone,
                  "id": element.id,
                  "type": "zone"
                };
                await SunmiPrinter.bindingPrinter();
                await SunmiPrinter.initPrinter();
                await SunmiPrinter.startTransactionPrint(true);
                await SunmiPrinter.printText(
                    "${element.ticket?.name ?? ''}\n${element.ticket?.category?.name ?? ''}   ");
                await SunmiPrinter.printText(
                    "MOBILE: ${element.phone ?? ''}       ");
                await SunmiPrinter.printText(
                    "PRICE: ${element.amount ?? ''}  ");
                await SunmiPrinter.printText(
                    "Date   : ${DateFormat().add_yMd().add_Hms().format(DateTime.now())}     \n");
                await SunmiPrinter.printQRCode(jsonEncode(data));

                await SunmiPrinter.printText("  ${element.id ?? ''}  ");
                await SunmiPrinter.printText(" \n\n   ** **  **  **  \n\n");
              }
              Get.offAllNamed(Routes.RIDE_TICKET);
            }

            // clearPreviousData();
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                'Session Expired. Please login again!', Colors.red);
            Get.offAllNamed(Routes.LOGIN);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            // EntryPurchaseResponse model =
            // EntryPurchaseResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast(AppConfigs.SOMETHING_WENT_WRONG, Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast("Check your Inputs correctly", Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          if (kDebugMode) {
            print('Error: $e');
          }
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: $e', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  void clearPreviousData() {
    totalTicketCounter.value = 0;
    totalPrice.value = 0.0;
    zoneTicketItems.forEach((element) {
      element.ticketCount = 0;
    });
    update();
    refresh();
  }

  void decrementValue(int index) {
    if (zoneTicketItems[index].ticketCount == 0) {
    } else {
      zoneTicketItems[index].ticketCount--;
    }
    inputControllers[index].text =
        zoneTicketItems[index].ticketCount.toString();
    update();
    refresh();
  }

  void incrementValue(int index) {
    zoneTicketItems[index].ticketCount++;
    inputControllers[index].text =
        zoneTicketItems[index].ticketCount.toString();
    update();
    refresh();
  }
}
