// To parse this JSON data, do
//
//     final packageBuyResponse = packageBuyResponseFromJson(jsonString);

import 'dart:convert';

PackageBuyResponse packageBuyResponseFromJson(String str) =>
    PackageBuyResponse.fromJson(json.decode(str));

String packageBuyResponseToJson(PackageBuyResponse data) =>
    json.encode(data.toJson());

class PackageBuyResponse {
  PackageBuyData? data;
  List<dynamic>? rejected;
  String? message;

  PackageBuyResponse({
    this.data,
    this.rejected,
    this.message,
  });

  factory PackageBuyResponse.fromJson(Map<String, dynamic> json) =>
      PackageBuyResponse(
        data:
            json["data"] == null ? null : PackageBuyData.fromJson(json["data"]),
        rejected: json["rejected"] == null
            ? []
            : List<dynamic>.from(json["rejected"]!.map((x) => x)),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "rejected":
            rejected == null ? [] : List<dynamic>.from(rejected!.map((x) => x)),
        "message": message,
      };
}

class PackageBuyData {
  List<Entry>? entries;
  List<RideData>? rides;

  PackageBuyData({
    this.entries,
    this.rides,
  });

  factory PackageBuyData.fromJson(Map<String, dynamic> json) => PackageBuyData(
        entries: json["entries"] == null
            ? []
            : List<Entry>.from(json["entries"]!.map((x) => Entry.fromJson(x))),
        rides: json["rides"] == null
            ? []
            : List<RideData>.from(
                json["rides"]!.map((x) => RideData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "entries": entries == null
            ? []
            : List<dynamic>.from(entries!.map((x) => x.toJson())),
        "rides": rides == null
            ? []
            : List<dynamic>.from(rides!.map((x) => x.toJson())),
      };
}

class Entry {
  int? id;
  int? parkId;
  int? branchId;
  dynamic? entryTicketId;
  String? phone;
  String? key;
  dynamic amount;
  dynamic? redeem;
  dynamic redeemAt;
  dynamic? createdBy;
  dynamic? updatedBy;
  dynamic deviceId;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? packageId;
  String? packageName;
  int? packageTicketId;
  int? packagePrice;
  EntryTicket? ticket;
  Branch? park;
  Branch? branch;
  Entry({
    this.id,
    this.parkId,
    this.branchId,
    this.entryTicketId,
    this.phone,
    this.key,
    this.amount,
    this.redeem,
    this.redeemAt,
    this.createdBy,
    this.updatedBy,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.packageId,
    this.packageName,
    this.packageTicketId,
    this.packagePrice,
    this.ticket,
    this.park,
    this.branch,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
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
        key: json["key"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        packageId: json["package_id"],
        packageName: json["package_name"],
        packageTicketId: json["package_ticket_id"],
        packagePrice: json["package_price"],
        ticket: json["ticket"] == null
            ? null
            : EntryTicket.fromJson(json["ticket"]),
        park: json["park"] == null ? null : Branch.fromJson(json["park"]),
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
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
        "key": key,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "package_id": packageId,
        "package_name": packageName,
        "package_ticket_id": packageTicketId,
        "package_price": packagePrice,
        "ticket": ticket?.toJson(),
        "park": park?.toJson(),
        "branch": branch?.toJson(),
      };
}

class Branch {
  int? id;
  String? name;

  Branch({
    this.id,
    this.name,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class EntryTicket {
  int? id;
  String? name;
  int? entryTicketTypeId;
  Type? type;

  EntryTicket({
    this.id,
    this.name,
    this.entryTicketTypeId,
    this.type,
  });

  factory EntryTicket.fromJson(Map<String, dynamic> json) => EntryTicket(
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
  int? parkId;
  dynamic? createdBy;
  dynamic? updatedBy;
  dynamic deviceId;
  dynamic? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Type({
    this.id,
    this.name,
    this.parkId,
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
        parkId: json["park_id"],
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
        "park_id": parkId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "device_id": deviceId,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class RideData {
  int? id;
  int? parkId;
  int? branchId;
  int? rideId;
  String? phone;
  dynamic amount;
  int? ticketId;
  dynamic? redeem;
  dynamic? createdBy;
  dynamic? updatedBy;
  dynamic deviceId;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic redeemAt;
  int? packageId;
  String? packageName;
  int? packageTicketId;
  int? packagePrice;
  RideTicket? ticket;
  String? key;

  Branch? park;
  Branch? branch;
  RideData(
      {this.id,
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
      this.packageId,
      this.packageName,
      this.packageTicketId,
      this.packagePrice,
      this.ticket,
      this.park,
      this.branch,
      this.key});

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
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
        key: json["key"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        redeemAt: json["redeem_at"],
        packageId: json["package_id"],
        packageName: json["package_name"],
        packageTicketId: json["package_ticket_id"],
        packagePrice: json["package_price"],
        ticket:
            json["ticket"] == null ? null : RideTicket.fromJson(json["ticket"]),
        park: json["park"] == null ? null : Branch.fromJson(json["park"]),
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
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
        "key": key,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "redeem_at": redeemAt,
        "package_id": packageId,
        "package_name": packageName,
        "package_ticket_id": packageTicketId,
        "package_price": packagePrice,
        "ticket": ticket?.toJson(),
        "park": park?.toJson(),
        "branch": branch?.toJson(),
      };
}

class RideTicket {
  int? id;
  String? name;
  int? ticketCategoryId;
  Category? category;

  RideTicket({
    this.id,
    this.name,
    this.ticketCategoryId,
    this.category,
  });

  factory RideTicket.fromJson(Map<String, dynamic> json) => RideTicket(
        id: json["id"],
        name: json["name"],
        ticketCategoryId: json["ticket_category_id"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
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
