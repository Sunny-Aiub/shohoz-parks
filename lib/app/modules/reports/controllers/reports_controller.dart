import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sohoz_park/app/http/request.dart';
import 'package:sohoz_park/app/utils/roles.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../../http/url.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/appconfigs.dart';
import '../models/reports_response.dart';
import 'dart:ui' as ui;

import '../models/scanner_reponse.dart';

class ReportsController extends GetxController {
  final GetStorage storage = GetStorage();

  final count = 0.obs;
  Rx<ReportData?> reportData = ReportData().obs;
  final isLoading = false.obs;
  var weightData = <Category>[].obs;
  var packageData = <Category>[].obs;

  var dateInput = TextEditingController();
  var intTimeInput = TextEditingController(text: '00:00:00');
  var outTimeInput = TextEditingController(text: '23:59:59');
  ScreenshotController screenshotController = ScreenshotController();

  // RxString platformVersion = 'Unknown'.obs;
  RxString statusPrinter = '0'.obs;
  RxString inTime = ''.obs;
  RxString outTime = ''.obs;

  RxString selectedRole = ''.obs;
  final totalScannedTicket = 0.obs;

  @override
  void onInit() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate); // 2016-01-25

    selectedRole.value = AppConfigs.userRoles[0];
    dateInput.text = formattedDate;
    //getReports(withText: true);

    // initPlatformState();
    getPrinterStatus();
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

// Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       // platformVersion = await FlutterPaxPrinterUtility.platformVersion ??
//       //    'Unknown platform version';
//       platformVersion = 'Unknown platform version';
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

  getPrinterStatus() async {
    // await FlutterPaxPrinterUtility.init;
    // PrinterStatus status = await FlutterPaxPrinterUtility.getStatus;
    // print(status);
    // if (status == PrinterStatus.SUCCESS) {
    //   statusPrinter.value = "1";
    // } else {
    //   statusPrinter.value = "0";
    // }
    update();
    // setState(() {
    //   if (status == PrinterStatus.SUCCESS) {
    //     statusPrinter = "1";
    //   } else {
    //     statusPrinter = "0";
    //   }
    // });
  }

  getReports({required bool withText}) {
    print('Bearer ${storage.read('token')}');
    print(
        '$BASE_URL/ticket/reports?startDate=${dateInput.text} ${intTimeInput.text}&endDate=${dateInput.text} ${outTimeInput.text}&role=${selectedRole.value}');
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(
            url:
                '$BASE_URL/ticket/reports?startDate=${dateInput.text} ${intTimeInput.text}&endDate=${dateInput.text} ${outTimeInput.text}&role=${selectedRole.value}',
            header: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${storage.read('token')}',
            });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.get();
          weightData.clear();
          totalScannedTicket.value = 0;
          update();
          print(response.statusCode);
          print(response.body);
          if (response.statusCode == 201) {
            EasyLoading.dismiss();

            if (selectedRole.value == UserRoles.ENTRY_TICKET_SELLER.name) {
              ReportsResponse model =
                  ReportsResponse.fromJson(jsonDecode(response.body));
              reportData.value = model.data;
              isLoading.value = false;
              update();
              var data = model.data?.types;
              if (data?.keys.isNotEmpty == true) {
                model.data?.types!.forEach((key, value) {
                  weightData.add(Category(name: key, amount: value.toString()));
                  update();
                });

                if (model.data?.packages != null) {
                  model.data?.packages!.forEach((key, value) {
                    packageData
                        .add(Category(name: key, amount: value.toString()));
                    update();
                  });
                }

                update();
                // weightData.value = data.map((e) => Category(name: e.key, amount: e.value.toString() )).toList();
                print(packageData.length);
              }
            } else if (selectedRole.value ==
                UserRoles.ZONE_TICKET_SELLER.name) {
              ReportsResponse model =
                  ReportsResponse.fromJson(jsonDecode(response.body));
              reportData.value = model.data;
              isLoading.value = false;
              update();
              var data = model.data?.rides;
              if (data?.keys.isNotEmpty == true) {
                model.data?.rides!.forEach((key, value) {
                  weightData.add(Category(name: key, amount: value.toString()));
                  update();
                });
                // weightData.value = data.map((e) => Category(name: e.key, amount: e.value.toString() )).toList();
                print(weightData.length);
                update();
              }
            } else if (selectedRole.value == UserRoles.TICKET_SCANNER.name) {
              ScannerReportResponse model =
                  ScannerReportResponse.fromJson(jsonDecode(response.body));
              isLoading.value = false;
              reportData.value = ReportData(
                  parkName: model.data?.entry?.parkName,
                  branchName: model.data?.entry?.branchName,
                  sellerFirstName: model.data?.entry?.sellerFirstName,
                  sellerLastName: model.data?.entry?.sellerLastName);
              update();
              var data = model.data?.entry?.types;
              if (data?.keys.isNotEmpty == true) {
                model.data?.entry!.types!.forEach((key, value) {
                  var number = int.parse(value.toString());
                  weightData.add(Category(name: key, amount: value.toString()));
                  totalScannedTicket.value =
                      totalScannedTicket.value + int.parse(value.toString());
                  update();
                });
                // weightData.value = data.map((e) => Category(name: e.key, amount: e.value.toString() )).toList();
                print(weightData.length);
                update();
              }

              var data2 = model.data?.ride?.rides;
              if (data2?.keys.isNotEmpty == true) {
                model.data?.ride!.rides!.forEach((key, value) {
                  weightData.add(Category(name: key, amount: value.toString()));
                  totalScannedTicket.value =
                      totalScannedTicket.value + int.parse(value.toString());
                  update();
                });
                // weightData.value = data.map((e) => Category(name: e.key, amount: e.value.toString() )).toList();
                print(weightData.length);
                update();
              }
            } else {}
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                'Session Expired. Please login again!', Colors.red);
            Get.offAllNamed(Routes.LOGIN);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            AppConfigs.showToast(AppConfigs.SOMETHING_WENT_WRONG, Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast("Check your Inputs correctly", Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          print('Error: $e');
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: ${e.toString()}', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  printEntryTicketReport(ReportData reportData) async {
    Uint8List byte =
        await getImageFromAsset('assets/images/logos-Photoroom.jpg');
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);

    await SunmiPrinter.printText(
        "\n${reportData?.parkName ?? ''} "
        "\n${reportData?.branchName ?? ''}  "
        "\nUser    : ${reportData?.sellerFirstName ?? ''} ${reportData?.sellerLastName ?? ''} "
        "\nDate   : ${dateInput.text.toString()} \nTime: ${intTimeInput.text} - ${outTimeInput.text} \n "
        "\n- - - - - - - - - - - - - - -\n",
        style: SunmiStyle(align: SunmiPrintAlign.LEFT));

    weightData.forEach((element) async {
      await SunmiPrinter.printText(
          '${element.name} :   ${element?.amount ?? 0}\n');
    });

    await SunmiPrinter.printText("- - - - - - - - - - - - - - -");

    packageData.forEach((element) async {
      await SunmiPrinter.printText(
          '${element.name} :   ${element?.amount ?? 0}\n');
    });

    await SunmiPrinter.printText("- - - - - - - - - - - - - - -");

    await SunmiPrinter.printText(
      "Total Ticket Sold:        ${reportData?.soldToday ?? 0} \n",
    );
    await SunmiPrinter.printText(
      "Total Earnings:          ${reportData?.todayEarnings ?? 0}\n",
    );
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.printText(
      "\n\n\n          *******               \n\n",
    );
    SunmiPrinter.exitTransactionPrint(true);
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

  printRideTicketReport(ReportData reportData) async {
    Uint8List byte =
        await getImageFromAsset('assets/images/logos-Photoroom.jpg');
    SunmiPrinter.bindingPrinter();
    SunmiPrinter.initPrinter();
    SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.printText("${reportData?.parkName ?? ''}    \n");
    await SunmiPrinter.printText("${reportData?.branchName ?? ''}     \n");
    await SunmiPrinter.printText("\n");

    await SunmiPrinter.printText(
        "User    : ${reportData?.sellerFirstName ?? ''} ${reportData?.sellerLastName ?? ''}           \n");
    await SunmiPrinter.printText(
        "Date   : ${dateInput.text.toString()} \nTime: ${intTimeInput.text} - ${outTimeInput.text} \n");

    await SunmiPrinter.printText("- - - - - - - - - - - - - - - \n");

    weightData.forEach((element) async {
      await SunmiPrinter.printText(
          '${element.name}  :   ${element?.amount ?? 0}\n');
    });

    await SunmiPrinter.printText("- - - - - - - - - - - - - - - \n");
    await SunmiPrinter.printText(
        "Total Ticket Sold:        ${reportData?.soldToday ?? 0}\n"); //Total Earnings Today :${reportData?.todayEarnings ?? 0}
    await SunmiPrinter.printText(
        "Total Earnings:          ${reportData?.todayEarnings ?? 0}\n"); //Total Earnings Today :${reportData?.todayEarnings ?? 0}

    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.printText(
      "\n\n\n          *******               \n\n",
    );
    SunmiPrinter.exitTransactionPrint(true);
  }

  Future<void> scannerReport(ReportData reportData) async {
    Uint8List byte =
        await getImageFromAsset('assets/images/logos-Photoroom.jpg');
    SunmiPrinter.bindingPrinter();
    SunmiPrinter.initPrinter();
    SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.printText("${reportData?.parkName ?? ''}    \n");
    await SunmiPrinter.printText("${reportData?.branchName ?? ''}     \n");
    await SunmiPrinter.printText("\n");

    await SunmiPrinter.printText(
        "User    : ${reportData?.sellerFirstName ?? ''} ${reportData?.sellerLastName ?? ''}           \n");
    await SunmiPrinter.printText(
        "Date   : ${dateInput.text.toString()} \nTime: ${intTimeInput.text} - ${outTimeInput.text} \n");

    await SunmiPrinter.printText("- - - - - - - - - - - - - - - \n");

    weightData.forEach((element) async {
      await SunmiPrinter.printText(
          '${element.name}  :   ${element?.amount ?? 0}\n');
    });

    await SunmiPrinter.printText("- - - - - - - - - - - - - - - \n");
    await SunmiPrinter.printText(
        "Total Ticket Scanned: ${totalScannedTicket ?? 0}\n");
    //Total Earnings Today :${reportData?.todayEarnings ?? 0}

    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.printText(
      "\n\n\n          *******               \n\n",
    );
    SunmiPrinter.exitTransactionPrint(true);
  }

  void clearData() {
    reportData.value = ReportData();
    weightData.clear();
    packageData.clear();
    intTimeInput = TextEditingController(text: '00:00:00');
    outTimeInput = TextEditingController(text: '23:59:59');
    update();
  }

  void clearDataWithoutTime() {
    reportData.value = ReportData();
    weightData.clear();
    packageData.clear();
    update();
  }
}

class Category {
  final String name;
  final String? amount;

  Category({required this.name, this.amount});
}
