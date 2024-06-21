// To parse this JSON data, do
//
//     final reportsResponse = reportsResponseFromJson(jsonString);

import 'dart:convert';

ReportsResponse reportsResponseFromJson(String str) => ReportsResponse.fromJson(json.decode(str));

String reportsResponseToJson(ReportsResponse data) => json.encode(data.toJson());

class ReportsResponse {
  ReportData? data;
  String? message;

  ReportsResponse({
    this.data,
    this.message,
  });

  factory ReportsResponse.fromJson(Map<String, dynamic> json) => ReportsResponse(
    data: json["data"] == null ? null : ReportData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
  };
}

class ReportData {
  String? parkName;
  String? branchName;
  String? sellerFirstName;
  String? sellerLastName;
  String? sellerPhone;
  DateTime? fromDate;
  DateTime? untillDate;
  Map<String,dynamic>? rides;
  Map<String,dynamic>? types;

  Map<String,dynamic>? packages;
  int? soldToday;
  dynamic? todayEarnings;
  int? totalSold;
  dynamic totalEarnings;

  ReportData({
    this.parkName,
    this.branchName,
    this.sellerFirstName,
    this.sellerLastName,
    this.sellerPhone,
    this.fromDate,
    this.untillDate,
    this.rides,this.types,
    this.soldToday,
    this.todayEarnings,
    this.totalSold,
    this.totalEarnings,this.packages,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
    parkName: json["parkName"],
    branchName: json["branchName"],
    sellerFirstName: json["sellerFirstName"],
    sellerLastName: json["sellerLastName"],
    sellerPhone: json["sellerPhone"],
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    untillDate: json["untillDate"] == null ? null : DateTime.parse(json["untillDate"]),
    rides: json["rides"] == null ? null : json["rides"],
    types: json["types"] == null ? null : json["types"],
    packages: json["packages"] == null ? null : json["packages"],
    soldToday: json["soldToday"],
    todayEarnings: json["todayEarnings"],
    totalSold: json["totalSold"],
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
    "packages": packages ,

    "soldToday": soldToday,
    "todayEarnings": todayEarnings,
    "totalSold": totalSold,
    "totalEarnings": totalEarnings,
  };
}

class CategorySold {
  int? adults;
  int? children;
  int? infants;

  CategorySold({
    this.adults,
    this.children,
    this.infants,
  });

  factory CategorySold.fromJson(Map<String, dynamic> json) => CategorySold(
    adults: json["Adults"],
    children: json["Children"],
    infants: json["Infants"],
  );

  Map<String, dynamic> toJson() => {
    "Adults": adults,
    "Children": children,
    "Infants": infants,
  };
}
