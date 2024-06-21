// To parse this JSON data, do
//
//     final rideScanResponse = rideScanResponseFromJson(jsonString);

import 'dart:convert';

RideScanResponse rideScanResponseFromJson(String str) => RideScanResponse.fromJson(json.decode(str));

String rideScanResponseToJson(RideScanResponse data) => json.encode(data.toJson());

class RideScanResponse {
  List<RideScanDatum>? data;
  String? message;

  RideScanResponse({
    this.data,
    this.message,
  });

  factory RideScanResponse.fromJson(Map<String, dynamic> json) => RideScanResponse(
    data: json["data"] == null ? [] : List<RideScanDatum>.from(json["data"]!.map((x) => RideScanDatum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class RideScanDatum {
  String? ticketId;
  String? totalTickets;
  String? totalAmount;
  List<TicketElement>? tickets;
  PurpleTicket? ticket;

  RideScanDatum({
    this.ticketId,
    this.totalTickets,
    this.totalAmount,
    this.tickets,
    this.ticket,
  });

  factory RideScanDatum.fromJson(Map<String, dynamic> json) => RideScanDatum(
    ticketId: json["ticket_id"],
    totalTickets: json["total_tickets"],
    totalAmount: json["total_amount"],
    tickets: json["tickets"] == null ? [] : List<TicketElement>.from(json["tickets"]!.map((x) => TicketElement.fromJson(x))),
    ticket: json["ticket"] == null ? null : PurpleTicket.fromJson(json["ticket"]),
  );

  Map<String, dynamic> toJson() => {
    "ticket_id": ticketId,
    "total_tickets": totalTickets,
    "total_amount": totalAmount,
    "tickets": tickets == null ? [] : List<dynamic>.from(tickets!.map((x) => x.toJson())),
    "ticket": ticket?.toJson(),
  };
}

class PurpleTicket {
  int? id;
  String? name;

  PurpleTicket({
    this.id,
    this.name,
  });

  factory PurpleTicket.fromJson(Map<String, dynamic> json) => PurpleTicket(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class TicketElement {
  int? id;
  dynamic? parkId;
  dynamic? branchId;
  String? rideId;
  String? phone;
  String? amount;
  String? ticketId;
  String? redeem;
  dynamic? createdBy;
  dynamic? updatedBy;
  String? deviceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? redeemAt;

  TicketElement({
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
    this.createdAt,
    this.updatedAt,
    this.redeemAt,
  });

  factory TicketElement.fromJson(Map<String, dynamic> json) => TicketElement(
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    redeemAt: json["redeem_at"] == null ? null : DateTime.parse(json["redeem_at"]),
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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "redeem_at": redeemAt?.toIso8601String(),
  };
}
