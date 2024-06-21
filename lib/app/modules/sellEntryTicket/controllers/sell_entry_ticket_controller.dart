// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sohoz_park/app/data/sellEntryTicket/ticket.dart';
import 'package:sohoz_park/app/http/request.dart';
import 'package:sohoz_park/app/http/url.dart';
import 'package:sohoz_park/app/modules/sellEntryTicket/models/entry_ticket_list_response.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../../sunmi/sunmi_service.dart';
import '../models/ticket_buy_response.dart';

class SellEntryTicketController extends GetxController {
  final sellTicketItems = <TicketTypes>[].obs;
  final inputControllers = <TextEditingController>[].obs;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var mobileNumberCtlr = TextEditingController();
  final GetStorage storage = GetStorage();

  final formKey = GlobalKey<FormState>();
  var totalTicketCounter = 0.obs;
  var totalPrice = 0.0.obs;

  RxString platformVersion = 'Unknown'.obs;
  RxString statusPrinter = '0'.obs;
  bool isLoading = false;

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

  getTicketTypes() {
    print('calling entry ticke tyoes');
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request =
            Request(url: BASE_URL + API_ENTRY_TICKET_TYPES, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.get();

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            EntryTicketListResponse model =
                EntryTicketListResponse.fromJson(jsonDecode(response.body));
print(response.body);
            sellTicketItems.value = model.data ?? [];
            update();
            sellTicketItems.forEach((element) {
              inputControllers.add(TextEditingController());
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
    sellTicketItems.forEach((element) {
      totalTicketCounter.value = totalTicketCounter.value + element.ticketCount;
      update();
    });
  }

  void getTotalPrice() {
    totalPrice.value = 0;
    update();
    sellTicketItems.forEach((element) {
      totalPrice.value = totalPrice.value +
          (double.parse(element.price.toString()!) * element.ticketCount);
      update();
    });
  }

  void buyEntryTicket() {
    print('buying entry ticket ');

    var tickets = [];
    sellTicketItems.forEach((element) {
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
    print(tickets.length);
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request =
            Request(url: BASE_URL + API_ENTRY_TICKET_BUY, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        }, body: {
          "phone": mobileNumberCtlr.text,
          "tickets": tickets,
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();
          print(response.body);
          if (response.statusCode == 201) {
            EasyLoading.dismiss();
            EntryPurchaseResponse model =
                EntryPurchaseResponse.fromJson(jsonDecode(response.body));

            update();
            AppConfigs.showToast(model.message, Colors.green);

            if (model.data != null) {
              // model.data?.forEach((element)
              for(Datum element in model.data!) {
                var data = {
                  "phone": element.phone,
                  "id": element.id,
                  "type": "entry"
                };
                // SunmiPrinter.bindingPrinter().then((value) {
                //   SunmiPrinter.initPrinter().then((value) {
                //     SunmiPrinter.lineWrap(1).then((value) {
                //       SunmiPrinter.printText(
                //           "ENTRY TICKET  "
                //               "\n${element.ticket?.name ?? ''} "
                //               "\n${element.ticket?.type?.name ?? ''} "
                //               "\nMOBILE: ${element.phone ?? ''} "
                //               "\nPRICE: ${element.amount ?? ''} "
                //               "\nDate   : ${DateFormat().add_yMd()
                //               .add_Hms()
                //               .format(DateTime.now())} ",
                //           style: SunmiStyle(align: SunmiPrintAlign.LEFT))
                //           .then((value) {
                //         SunmiPrinter.printQRCode(jsonEncode(data))
                //             .then((value) {
                //           SunmiPrinter.lineWrap(2).then((value) {
                //             SunmiPrinter.startTransactionPrint(true).then((
                //                 value) {
                //               SunmiPrinter.exitTransactionPrint(true);
                //               Timer(const Duration(seconds: 30), () {
                //                 print("print after every 3 seconds");
                //               });
                //             });
                //           });
                //         });
                //       });
                //     });
                //   });
                // });

                // await SunmiPrinter.bindingPrinter();
                // await SunmiPrinter.initPrinter();
                // await SunmiPrinter.startTransactionPrint(true);
                await SunmiPrinter.bindingPrinter();
                await SunmiPrinter.initPrinter();
                await SunmiPrinter.startTransactionPrint(true);

                await SunmiPrinter.printText(" ENTRY TICKET   ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText(" ${element.ticket?.name ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText(" ${element.ticket?.type?.name ?? ''}",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText(" MOBILE: ${element.phone ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText(" PRICE: ${element.amount ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText(
                    " Date   : ${DateFormat().add_yMd().add_Hms().format(DateTime.now())} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText("\n");
                await SunmiPrinter.printQRCode(jsonEncode(data));
                await SunmiPrinter.printText("    ${element.id ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("\n\n");
                await SunmiPrinter.exitTransactionPrint(true);

                // });
              }
            }
            Get.offAllNamed(Routes.SELL_ENTRY_TICKET);

            clearPreviousData();
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                'Session Expired. Please login again!', Colors.red);
            Get.offAndToNamed(Routes.LOGIN);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            EntryPurchaseResponse model =
                EntryPurchaseResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast(model.message, Colors.red);
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
    sellTicketItems.forEach((element) {
      element.ticketCount = 0;
    });
    update();
    refresh();
  }

  void decrementValue(int index) {
    if (sellTicketItems[index].ticketCount == 0) {
    } else {
      sellTicketItems[index].ticketCount--;
    }
    inputControllers[index].text =
        sellTicketItems[index].ticketCount.toString();
    update();
    refresh();
  }

  void incrementValue(int index) {
    sellTicketItems[index].ticketCount++;
    inputControllers[index].text =
        sellTicketItems[index].ticketCount.toString();
    update();
    refresh();
  }
}
