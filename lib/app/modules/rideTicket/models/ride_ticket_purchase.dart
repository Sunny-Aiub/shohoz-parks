// To parse this JSON data, do
//
//     final rideTicketPurchaseResponse = rideTicketPurchaseResponseFromJson(jsonString);

import 'dart:convert';

RideTicketPurchaseResponse rideTicketPurchaseResponseFromJson(String str) => RideTicketPurchaseResponse.fromJson(json.decode(str));

String rideTicketPurchaseResponseToJson(RideTicketPurchaseResponse data) => json.encode(data.toJson());

class RideTicketPurchaseResponse {
  List<Datum>? data;
  List<dynamic>? rejected;
  String? message;

  RideTicketPurchaseResponse({
    this.data,
    this.rejected,
    this.message,
  });

  factory RideTicketPurchaseResponse.fromJson(Map<String, dynamic> json) => RideTicketPurchaseResponse(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    rejected: json["rejected"] == null ? [] : List<dynamic>.from(json["rejected"]!.map((x) => x)),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "rejected": rejected == null ? [] : List<dynamic>.from(rejected!.map((x) => x)),
    "message": message,
  };
}

class Datum {
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
  DateTime? redeemAt;
  Ticket? ticket;

  Datum({
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
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    redeemAt: json["redeem_at"] == null ? null : DateTime.parse(json["redeem_at"]),
    ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "redeem_at": redeemAt?.toIso8601String(),
    "ticket": ticket?.toJson(),
  };
}

class Ticket {
  int? id;
  String? name;
  dynamic ticketCategoryId;
  Category? category;

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
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ticket_category_id": ticketCategoryId,
    "category": category?.toJson(),
  };
}

class Category {
  int? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
