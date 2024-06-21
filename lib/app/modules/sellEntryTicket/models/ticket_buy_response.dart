// To parse this JSON data, do
//
//     final entryPurchaseResponse = entryPurchaseResponseFromJson(jsonString);

import 'dart:convert';

EntryPurchaseResponse entryPurchaseResponseFromJson(String str) => EntryPurchaseResponse.fromJson(json.decode(str));

String entryPurchaseResponseToJson(EntryPurchaseResponse data) => json.encode(data.toJson());

class EntryPurchaseResponse {
  List<Datum>? data;
  List<Datum>? rejected;
  String? message;

  EntryPurchaseResponse({
    this.data,
    this.rejected,
    this.message,
  });

  factory EntryPurchaseResponse.fromJson(Map<String, dynamic> json) => EntryPurchaseResponse(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    rejected: json["rejected"] == null ? [] :  List<Datum>.from(json["rejected"]!.map((x) => x)),
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
  dynamic entryTicketId;
  String? phone;
  dynamic amount;
  dynamic redeem;
  DateTime? redeemAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deviceId;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Ticket? ticket;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    parkId: json["park_id"],
    branchId: json["branch_id"],
    entryTicketId: json["entry_ticket_id"],
    phone: json["phone"],
    amount: json["amount"],
    redeem: json["redeem"],
    redeemAt: json["redeem_at"] == null ? null : DateTime.parse(json["redeem_at"]),
    createdBy: json["created_by"] ,
    updatedBy: json["updated_by"] ,
    deviceId: json["device_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "redeem_at": redeemAt?.toIso8601String(),
    "created_by": createdBy ,
    "updated_by": updatedBy ,
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
  dynamic branchId;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deviceId;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Type({
    this.id,
    this.name,
    this.branchId,
    this.createdBy,
    this.updatedBy,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
    branchId: json["branch_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deviceId: json["device_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "branch_id": branchId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}
