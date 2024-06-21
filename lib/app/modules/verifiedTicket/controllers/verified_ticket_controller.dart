import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sohoz_park/app/http/request.dart';
import 'package:sohoz_park/app/http/url.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';

import '../../../routes/app_pages.dart';
import '../../scan/data/ride_scan_response.dart';

class VerifiedTicketController extends GetxController {
  //TODO: Implement VerifiedTicketController

  final count = 0.obs;

  var isLoading = false.obs;
  var rideData = <RideScanDatum>[].obs;
  var ids = <int>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    AppConfigs.rideData.forEach((element) {
      rideData.add(element);
    });
    update();
    refresh();
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

  redeemTicket(String phoneNumber) {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: '$BASE_URL/ticket/ride/redeem', body: {
          "phone": phoneNumber,
          "id": ids.value
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
          print(response);
          ids.clear();
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            isLoading.value = false;
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

  void callRedeemAPI(int index) {

    rideData[index].tickets!.forEach((element) {
      ids.value.add(element.id!);
    });

    update();
    refresh();
    if (ids.value.isNotEmpty) {
      redeemTicket(rideData[index].tickets?.first.phone ?? '');

    } else {
      AppConfigs.showToast("NO ID FOUND", Colors.red);
    }
  }
}
