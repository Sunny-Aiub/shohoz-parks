import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sohoz_park/app/http/request.dart';
import 'package:sohoz_park/app/http/url.dart';
import 'package:sohoz_park/app/modules/login/models/login_response.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';
import 'package:sohoz_park/app/utils/roles.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  var mobileNumberCtlr = TextEditingController();
  var passwordCtlr = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    print(GetStorage().read('token'));
    if (GetStorage().read('token') != "") {
      print('data found');
      logoutFromDevice();
    } else {
      print('data null');
    }
  }

  getLogin(String username, String password) {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request = Request(url: BASE_URL + API_SIGN_IN, body: {
          'phone': mobileNumberCtlr.text.toString().trim(),
          'password': passwordCtlr.text.toString().trim(),
        }, header: {
          'Content-Type': 'application/json'
        });

        try {
          // Perform the network request
          EasyLoading.show();
          var response = await request.post();
          print(response.statusCode);

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            LoginResponse model =
                LoginResponse.fromJson(jsonDecode(response.body));
            AppConfigs.accessToken = model.data?.token ?? "";
            AppConfigs.currentUser = model.data?.user;
            AppConfigs.currentUser?.phone = mobileNumberCtlr.text;
            AppConfigs.userRoles = model.data?.roles ?? [];
            AppConfigs.rides = model.data?.rides ?? [];
            AppConfigs.resetData();
            if (AppConfigs.userRoles
                    .contains(UserRoles.ENTRY_TICKET_SELLER.name) ==
                true) {
              AppConfigs.isEntryTicketSeller = true;
            }
            if (AppConfigs.userRoles
                    .contains(UserRoles.ZONE_TICKET_SELLER.name) ==
                true) {
              AppConfigs.isZoneTicketSeller = true;
            }
            if (AppConfigs.userRoles.contains(UserRoles.TICKET_SCANNER.name) ==
                true) {
              AppConfigs.isTicketScanner = true;
            }
            GetStorage().write('token', model.data?.token.toString() ?? "");
            GetStorage().write('isLoggedIn', true);

            Get.offAndToNamed(Routes.HOME);
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            LoginResponse model =
                LoginResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast(model.message.toString(), Colors.red);
          } else if (response.statusCode == 422) {
            EasyLoading.dismiss();
            AppConfigs.showToast(
                "Mobile Number or password is incorrect!", Colors.red);
          } else if (response.statusCode == 302) {
            EasyLoading.dismiss();
            LoginResponse model =
                LoginResponse.fromJson(jsonDecode(response.body));
            AppConfigs.showToast(model.message, Colors.red);
          } else {
            EasyLoading.dismiss();
            AppConfigs.showToast("Check your Inputs correctly", Colors.red);
          }
        } catch (e) {
          // Handle other errors, such as network issues
          print('Error: $e');
          EasyLoading.dismiss();
          AppConfigs.showToast('Error: Server is Unreachable ', Colors.red);
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }

  logoutFromDevice() {
    Connectivity().checkConnectivity().then((connection) async {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        Request request =
            Request(url: BASE_URL + API_SIGN_OUT, body: null, header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('token')}',
        });

        try {
          var response = await request.post();
          EasyLoading.dismiss();
          print(response.statusCode);
          if (response.statusCode == 200) {
            GetStorage().remove('token');
          } else {
            print('token not found');
          }
        } catch (e) {
          // Handle other errors, such as network issues
          print('Error: $e');
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        AppConfigs.showToast("Check your Internet Connection", Colors.red);
      }
    });
  }
}
