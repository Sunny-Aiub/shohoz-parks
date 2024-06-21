// To parse this JSON data, do
//
//     final entryScanResponse = entryScanResponseFromJson(jsonString);

import 'dart:convert';

EntryScanResponse entryScanResponseFromJson(String str) => EntryScanResponse.fromJson(json.decode(str));

String entryScanResponseToJson(EntryScanResponse data) => json.encode(data.toJson());

class EntryScanResponse {
  Data? data;
  String? message;

  EntryScanResponse({
    this.data,
    this.message,
  });

  factory EntryScanResponse.fromJson(Map<String, dynamic> json) => EntryScanResponse(
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
  dynamic entryTicketId;
  String? phone;
  dynamic amount;
  dynamic redeem;
  dynamic redeemAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deviceId;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Ticket? ticket;

  Data({
    this.id,
    this.parkId,
    this.branchId,
    this.entryTicketId,
    this.phone,
    this.amount,
    this.redeem,
    this.redeemAt,
    this.createdBy,
    this.updatedBy,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.ticket,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    parkId: json["park_id"],
    branchId: json["branch_id"],
    entryTicketId: json["entry_ticket_id"],
    phone: json["phone"],
    amount: json["amount"],
    redeem: json["redeem"],
    redeemAt: json["redeem_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deviceId: json["device_id"],
    status: json["status"],
    createdAt: json["created_at"] ,//== null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] ,//== null ? null : DateTime.parse(json["updated_at"]),
    ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "park_id": parkId,
    "branch_id": branchId,
    "entry_ticket_id": entryTicketId,
    "phone": phone,
    "amount": amount,
    "redeem": redeem,
    "redeem_at": redeemAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt,//?.toIso8601String(),
    "updated_at": updatedAt,//?.toIso8601String(),
    "ticket": ticket?.toJson(),
  };
}

class Ticket {
  int? id;
  String? name;
  dynamic entryTicketTypeId;
  Type? type;

  Ticket({
    this.id,
    this.name,
    this.entryTicketTypeId,
    this.type,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    name: json["name"],
    entryTicketTypeId: json["entry_ticket_type_id"],
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "entry_ticket_type_id": entryTicketTypeId,
    "type": type?.toJson(),
  };
}

class Type {
  int? id;
  String? name;

  Type({
    this.id,
    this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
