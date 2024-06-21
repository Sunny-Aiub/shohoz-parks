// To parse this JSON data, do
//
//     final scannerReportResponse = scannerReportResponseFromJson(jsonString);

import 'dart:convert';

ScannerReportResponse scannerReportResponseFromJson(String str) => ScannerReportResponse.fromJson(json.decode(str));

String scannerReportResponseToJson(ScannerReportResponse data) => json.encode(data.toJson());

class ScannerReportResponse {
  Data? data;
  String? message;

  ScannerReportResponse({
    this.data,
    this.message,
  });

  factory ScannerReportResponse.fromJson(Map<String, dynamic> json) => ScannerReportResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Entry? entry;
  Entry? ride;

  Data({
    this.entry,
    this.ride,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    entry: json["entry"] == null ? null : Entry.fromJson(json["entry"]),
    ride: json["ride"] == null ? null : Entry.fromJson(json["ride"]),
  );

  Map<String, dynamic> toJson() => {
    "entry": entry?.toJson(),
    "ride": ride?.toJson(),
  };
}

class Entry {
  String? parkName;
  String? branchName;
  String? sellerFirstName;
  String? sellerLastName;
  String? sellerPhone;
  DateTime? fromDate;
  DateTime? untillDate;
  Map<String,dynamic>? rides;
  Map<String,dynamic>? types;
  int? soldToday;
  int? todayEarnings;
  int? totalEarnings;

  Entry({
    this.parkName,
    this.branchName,
    this.sellerFirstName,
    this.sellerLastName,
    this.sellerPhone,
    this.fromDate,
    this.untillDate,
    this.types,
    this.soldToday,
    this.todayEarnings,
    this.totalEarnings,
    this.rides,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    parkName: json["parkName"],
    branchName: json["branchName"],
    sellerFirstName: json["sellerFirstName"],
    sellerLastName: json["sellerLastName"],
    sellerPhone: json["sellerPhone"],
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    untillDate: json["untillDate"] == null ? null : DateTime.parse(json["untillDate"]),
    rides: json["rides"] == null ? null : json["rides"],
    types: json["types"] == null ? null : json["types"],    soldToday: json["soldToday"],
    todayEarnings: json["todayEarnings"],
    totalEarnings: json["totalEarnings"],
  );

  Map<String, dynamic> toJson() => {
    "parkName": parkName,
    "branchName": branchName,
    "sellerFirstName": sellerFirstName,
    "sellerLastName": sellerLastName,
    "sellerPhone": sellerPhone,
    "fromDate": fromDate?.toIso8601String(),
    "untillDate": untillDate?.toIso8601String(),
    "rides": rides ,
    "types": types ,
    "soldToday": soldToday,
    "todayEarnings": todayEarnings,
    "totalEarnings": totalEarnings,
   };
}

