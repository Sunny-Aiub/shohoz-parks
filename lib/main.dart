import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'app/commons/widgets/lifecycle_handler.dart';
import 'app/http/request.dart';
import 'app/http/url.dart';
import 'app/routes/app_pages.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "dailyApiCall") {
      // Call your API here
       await logoutFromDevice();
      print('=======work manager working======');
    }
    return Future.value(true);
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
        print(response.statusCode);
        if (response.statusCode == 200) {
          GetStorage().remove('token');
        } else {
          print('token not found');
        }
      } catch (e) {
        // Handle other errors, such as network issues
        print('Error: $e');
      }
    } else {}
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await GetStorage.init();
  final getData = GetStorage();
  getData.writeIfNull('isLoggedIn', false);
  //
  // Get.put(LifeCycleController());
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // set to false in production
  );
  Workmanager().registerPeriodicTask(
    "dailyApiCallTask",
    "dailyApiCall",
    frequency: const Duration(hours: 1),
    // initialDelay: Duration(seconds: 10), // initial delay for testing
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  runApp(
    GetMaterialApp(
      title: "Sohoz Parks",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
    ),
  );
}
