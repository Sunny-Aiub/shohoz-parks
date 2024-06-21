// To parse this JSON data, do
//
//     final rideSingleScanResponse = rideSingleScanResponseFromJson(jsonString);

import 'dart:convert';

RideSingleScanResponse rideSingleScanResponseFromJson(String str) => RideSingleScanResponse.fromJson(json.decode(str));

String rideSingleScanResponseToJson(RideSingleScanResponse data) => json.encode(data.toJson());

class RideSingleScanResponse {
  Data? data;
  String? message;

  RideSingleScanResponse({
    this.data,
    this.message,
  });

  factory RideSingleScanResponse.fromJson(Map<String, dynamic> json) => RideSingleScanResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  int? id;
  dynamic parkId;
  dynamic branchId;
  dynamic rideId;
  String? phone;
  dynamic amount;
  dynamic ticketId;
  dynamic redeem;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deviceId;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  dynamic redeemAt;
  Ticket? ticket;
  PermittedRide? ride;

  Data({
    this.id,
    this.parkId,
    this.branchId,
    this.rideId,
    this.phone,
    this.amount,
    this.ticketId,
    this.redeem,
    this.createdBy,
    this.updatedBy,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.redeemAt,
    this.ticket,
    this.ride,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    parkId: json["park_id"],
    branchId: json["branch_id"],
    rideId: json["ride_id"],
    phone: json["phone"],
    amount: json["amount"],
    ticketId: json["ticket_id"],
    redeem: json["redeem"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deviceId: json["device_id"],
    status: json["status"],
    createdAt: json["created_at"],// == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],// == null ? null : DateTime.parse(json["updated_at"]),
    redeemAt: json["redeem_at"],// == null ? null : DateTime.parse(json["redeem_at"]),
    ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
    ride: json["ride"] == null ? null : PermittedRide.fromJson(json["ride"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "park_id": parkId,
    "branch_id": branchId,
    "ride_id": rideId,
    "phone": phone,
    "amount": amount,
    "ticket_id": ticketId,
    "redeem": redeem,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt,//?.toIso8601String(),
    "updated_at": updatedAt,//?.toIso8601String(),
    "redeem_at": redeemAt,//?.toIso8601String(),
    "ticket": ticket?.toJson(),
    "ride": ride?.toJson(),
  };
}

class PermittedRide {
  int? id;
  String? name;

  PermittedRide({
    this.id,
    this.name,
  });

  factory PermittedRide.fromJson(Map<String, dynamic> json) => PermittedRide(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Ticket {
  int? id;
  String? name;
  dynamic ticketCategoryId;
  PermittedRide? category;

  Ticket({
    this.id,
    this.name,
    this.ticketCategoryId,
    this.category,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    name: json["name"],
    ticketCategoryId: json["ticket_category_id"],
    category: json["category"] == null ? null : PermittedRide.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ticket_category_id": ticketCategoryId,
    "category": category?.toJson(),
  };
}
