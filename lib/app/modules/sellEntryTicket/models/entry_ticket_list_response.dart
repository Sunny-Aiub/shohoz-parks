// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final entryTicketListResponse = entryTicketListResponseFromJson(jsonString);

import 'dart:convert';

EntryTicketListResponse entryTicketListResponseFromJson(String str) =>
    EntryTicketListResponse.fromJson(json.decode(str));

String entryTicketListResponseToJson(EntryTicketListResponse data) =>
    json.encode(data.toJson());

class EntryTicketListResponse {
  List<TicketTypes>? data;
  String? message;

  EntryTicketListResponse({
    this.data,
    this.message,
  });

  factory EntryTicketListResponse.fromJson(Map<String, dynamic> json) =>
      EntryTicketListResponse(
        data: json["data"] == null
            ? []
            : List<TicketTypes>.from(
                json["data"]!.map((x) => TicketTypes.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class TicketTypes {
  int? id;
  dynamic parkId;
  dynamic branchId;
  dynamic entryTicketTypeId;
  String? name;
  dynamic price;
  dynamic duration;
  dynamic createdBy;
  dynamic updatedBy;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Type? type;

  int ticketCount;

  TicketTypes({
    this.id,
    this.parkId,
    this.branchId,
    this.entryTicketTypeId,
    this.name,
    this.price,
    this.duration,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.ticketCount,
    this.type,
  });

  factory TicketTypes.fromJson(Map<String, dynamic> json) => TicketTypes(
        id: json["id"],
        parkId: json["park_id"],
        branchId: json["branch_id"],
        entryTicketTypeId: json["entry_ticket_type_id"],
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        ticketCount: 0,
        type: json["type"] == null ? null : Type.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "park_id": parkId,
        "branch_id": branchId,
        "entry_ticket_type_id": entryTicketTypeId,
        "name": name,
        "price": price,
        "duration": duration,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
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
