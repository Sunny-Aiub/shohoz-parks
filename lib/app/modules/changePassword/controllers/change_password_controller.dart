import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sohoz_park/app/http/request.dart';

import '../../../http/url.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/appconfigs.dart';
import '../../login/models/login_response.dart';

class ChangePasswordController extends GetxController {
 
 
  RxBool isLoading = false.obs;
  var passwordCtlr = TextEditingController();
  var confirmPasswordCtlr = TextEditingController();
  var newPasswordCtlr = TextEditingController();
  
   var scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();
  final GetStorage storage = GetStorage();

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
  changePassword() {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + API_CHANGE_PASSWORD, body: {
          "old_password":passwordCtlr.text,
          "new_password":newPasswordCtlr.text,
          "confirm_password":confirmPasswordCtlr.text
        }, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',

        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();

          print(response.statusCode);
          print(response);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            LoginResponse model =
            LoginResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast(model.message.toString(), Colors.green);

            Get.offAllNamed(Routes.LOGIN);
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            LoginResponse model =
            LoginResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast("Your session expired! Please login again!", Colors.red);

            Get.offAllNamed(Routes.LOGIN);

            AppConfigs.showToast(model.message.toString(), Colors.red);
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

}
