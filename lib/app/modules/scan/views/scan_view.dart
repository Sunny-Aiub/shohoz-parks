import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/commons/home/views/left_menu.dart';
import 'package:sohoz_park/app/modules/scan/data/single_ride_scan_response.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';

import '../../login/models/login_response.dart';
import '../controllers/scan_controller.dart';

class ScanView extends StatefulWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  final ScanController controller = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
            "Validate Tickets",
            style: getSemiBoldStyle(
                fontSize: 22, color: ColorManager.inputFieldTitleColor333333),
          ),
        ),
        body: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: Get.width - 32,
                    decoration: BoxDecoration(
                        // color: ColorManager.backBlue,
                        border: Border.all(color: ColorManager.grayE4E4E4),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<Ride>(
                        isExpanded: true,
                        hint: Text(
                          'Select Your Ride',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorManager.primaryBlack,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorManager.primaryBlack,
                        ),
                        items: AppConfigs.rides
                            .map((Ride item) => DropdownMenuItem<Ride>(
                                  value: item,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      item.name.toString(),
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: controller.selectedRide,
                        onChanged: (Ride? value) {
                          if (value != null) {
                            controller.setRideValue(value!);
                            setState(() {
                              controller.selectedRide = value;
                            });
                          }
                        },
                        iconStyleData: IconStyleData(
                          openMenuIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: ColorManager.primaryBlack,
                            ),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorManager.primaryBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (controller.isScanning.value == false)
                    SvgPicture.asset(AssetConstant.scanIcon),

                  // if (controller.isScanning.value == true)

                  if (controller.isScanning.value == true)
                    SizedBox(
                      height: Get.width,
                      width: Get.width,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          QRView(
                            key: controller.qrKey,
                            overlay: QrScannerOverlayShape(
                              borderColor: Colors.red,
                              // borderRadius: 10,
                              // borderLength: 30,
                              // borderWidth: 10,
                            ),
                            onQRViewCreated: (QRViewController cltr) {
                              controller.qrViewController = cltr;
                              cltr.scannedDataStream.listen((event) {
                                if (event.code!.isNotEmpty) {
                                  String result = event.code!;
                                  var json = jsonDecode(result);
                                  print(result);
                                  print(json['phone']);
                                  var mobileNumber = json['phone'];
                                  var type = json['type'];
                                  var ticketID = json['id'];

                                  if (type == "entry") {
                                    controller.qrViewController?.pauseCamera();
                                    controller.changeScanningFlage();

                                    controller.scanEntryTicketApi(
                                        mobileNumber, type, ticketID);
                                  } else if (type == "zone") {
                                    controller.qrViewController?.pauseCamera();
                                    controller.changeScanningFlage();
                                    controller.scanRideTicketApi(
                                        mobileNumber, type, ticketID);
                                  } else {
                                    AppConfigs.showToast(
                                        "Invalid QR!", Colors.red);
                                    controller.qrViewController?.pauseCamera();
                                    controller.changeScanningFlage();
                                  }
                                }
                              });
                            },
                          ),
                          InkWell(
                              onTap: () async {
                                await controller.qrViewController
                                    ?.toggleFlash();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.lightbulb_circle,
                                    color: Colors.blue, size: 30),
                              ))
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 70,
                  ),
                  CustomButton(
                      width: Get.width - 32,
                      buttonTitle: 'Scan QR Code',
                      onPressed: () {
                        if(AppConfigs.isTicketScanner = true){
                          controller.changeScanningFlage();

                        }else{
                          if(controller.selectedRide == null){
                            AppConfigs.showToast(
                                'Select a ride first !',
                                Colors.red);
                          }else{
                            controller.changeScanningFlage();

                          }
                        }

                      })
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
