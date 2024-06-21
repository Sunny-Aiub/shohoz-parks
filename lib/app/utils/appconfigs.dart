import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sohoz_park/app/modules/login/models/login_response.dart';
import 'package:sohoz_park/app/modules/scan/data/ride_scan_response.dart';

class AppConfigs{

  static String accessToken = '';
    static List<String> userRoles = [];
  static List<Ride> rides = [];

  static bool isEntryTicketSeller = false;

  static bool isZoneTicketSeller = false;

  static bool isTicketScanner = false;

  static var SOMETHING_WENT_WRONG = "Something went wrong!";

  static User? currentUser;

  static RideScanResponse? rideScanResponse;

  static List<RideScanDatum> rideData = [];

  static String scannedPhoneNumber = '';

  
  static Future onBackPress(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Do you wish to exit?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => {Navigator.pop(context, false)},
            ),
            TextButton(
                onPressed: () => {Navigator.pop(context, true)},
                child: Text('Exit'))
          ],
        ));
  }

  static  showToast(text, color) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static resetData(){
    isEntryTicketSeller = false;
    isZoneTicketSeller = false;
    isTicketScanner = false;
    rideData= [];scannedPhoneNumber = '';
  }
  
}