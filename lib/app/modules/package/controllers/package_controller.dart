import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../../http/request.dart';
import '../../../http/url.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/appconfigs.dart';
import '../models/package_buy_response.dart';
import '../models/package_list_response.dart';

class PackageController extends GetxController {
  final inputControllers = <TextEditingController>[].obs;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var mobileNumberCtlr = TextEditingController();

  final sellTicketItems = <PackageDatum>[].obs;
  final GetStorage storage = GetStorage();

  var totalTicketCounter = 0.obs;
  var totalPrice = 0.0.obs;
  final formKey = GlobalKey<FormState>();
  var ticketSuffix = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getAllPackages();
  }

  getAllPackages() {
    print('calling packages');
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + API_ALL_PACKAGES, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.get();

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            print(response.body);
            PackageListResponse model =
                PackageListResponse.fromJson(jsonDecode(response.body));
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

  void buyPackageTicket() {
    print('buying package ticket ');

    var tickets = [];
    for (var element in sellTicketItems) {
      if (element.ticketCount > 0) {
        tickets.add(
          {
            "id": int.parse(element.id.toString()),
            "quantity": element.ticketCount
          },
        );
      }
    }
    update();
    print(tickets.length);
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + API_BUY_PACKAGES, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        }, body: {
          "phone": mobileNumberCtlr.text.isEmpty == true
              ? "01710000000"
              : mobileNumberCtlr.text,
          "packages": tickets,
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();
          print(response.body);
          if (response.statusCode == 201) {
            EasyLoading.dismiss();
            PackageBuyResponse model =
                PackageBuyResponse.fromJson(jsonDecode(response.body));

            update();
            AppConfigs.showToast(model.message, Colors.green);
            totalTicketCounter.value = 0;
            Uint8List byte =
            await getImageFromAsset('assets/images/logos-Photoroom.jpg');
            if (model.data?.entries != null) {
              // model.data?.forEach((element)
              for (Entry element in model.data!.entries!) {
                var data = {
                  "phone": element.phone,
                  "id": element.id,
                  "type": "entry"
                };

                totalTicketCounter.value = totalTicketCounter.value + 1;
                update();
                await SunmiPrinter.bindingPrinter();
                await SunmiPrinter.initPrinter();
                await SunmiPrinter.startTransactionPrint(true);
                await SunmiPrinter.printText("Package ID: ${element.key}",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Park: ${element.park?.name} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Branch: ${element.branch?.name} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Package Name: ${element.packageName} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("ENTRY TICKET   ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("${element.ticket?.name ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText(element.ticket?.type?.name ?? '',
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Customer Number: ${element.phone ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText(
                    "Package Price: ${element.packagePrice ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText(
                    "Date: ${DateFormat().add_yMd().add_Hms().format(DateTime.now())} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText("\n");
                await SunmiPrinter.printQRCode(jsonEncode(data));
                await SunmiPrinter.printText("  ${element.id ?? ''} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                await SunmiPrinter.printText("\nPowered by");
                await SunmiPrinter.printImage(byte);
                await SunmiPrinter.printText(" \n\n   ** **  **  **  \n\n");

                // });
              }

              for (RideData element in model.data!.rides!) {
                var data = {
                  "phone": element.phone,
                  "id": element.id,
                  "type": "zone"
                };
                totalTicketCounter.value = totalTicketCounter.value + 1;
                update();
                await SunmiPrinter.printText("Package ID: ${element.key}} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Park: ${element.park?.name} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Branch: ${element.branch?.name} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText("Package Name: ${element.packageName} ",
                    style: SunmiStyle(align: SunmiPrintAlign.LEFT));
                await SunmiPrinter.printText(
                    "${element.ticket?.name ?? ''}\n${element.ticket?.category?.name ?? ''}");
                await SunmiPrinter.printText(
                    "Customer Number: ${element.phone ?? ''}");
                await SunmiPrinter.printText(
                    "Package Price: ${element.packagePrice ?? ''}");
                await SunmiPrinter.printText(
                    "Date: ${DateFormat().add_yMd().add_Hms().format(DateTime.now())}     \n\n");
                await SunmiPrinter.printQRCode(jsonEncode(data));

                await SunmiPrinter.printText("  ${element.id ?? ''}  \n");
                await SunmiPrinter.printText("\nPowered by");
                await SunmiPrinter.printImage(byte);
                await SunmiPrinter.printText(" \n\n   ** **  **  **  \n\n");
              }
            }
            Get.offAllNamed(Routes.PACKAGE);

            clearPreviousData();
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                'Session Expired. Please login again!', Colors.red);
            Get.offAndToNamed(Routes.LOGIN);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            PackageBuyResponse model =
                PackageBuyResponse.fromJson(jsonDecode(response.body));
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
          // AppConfigs.showToast('Error: $e', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }
  Future<Uint8List> getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
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

  void clearPreviousData() {
    var totalTicketCounter;
    totalTicketCounter.value = 0;
    var totalPrice;
    totalPrice.value = 0.0;
    if(sellTicketItems.isNotEmpty == true){

      sellTicketItems.forEach((element) {
        element.ticketCount = 0;
      });
    }
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void openDrawer() {
    if (kDebugMode) {
      print('open');
    }
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
