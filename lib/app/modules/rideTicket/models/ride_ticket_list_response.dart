// To parse this JSON data, do
//
//     final rideTicketListResponse = rideTicketListResponseFromJson(jsonString);

import 'dart:convert';

RideTicketListResponse rideTicketListResponseFromJson(String str) =>
    RideTicketListResponse.fromJson(json.decode(str));

String rideTicketListResponseToJson(RideTicketListResponse data) =>
    json.encode(data.toJson());

class RideTicketListResponse {
  List<ZoneTickets>? data;
  String? message;

  RideTicketListResponse({
    this.data,
    this.message,
  });

  factory RideTicketListResponse.fromJson(Map<String, dynamic> json) =>
      RideTicketListResponse(
        data: json["data"] == null
            ? []
            : List<ZoneTickets>.from(
                json["data"]!.map((x) => ZoneTickets.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class ZoneTickets {
  int? id;
  dynamic parkId;
  dynamic branchId;
  dynamic rideId;
  String? name;
  dynamic ticketCategoryId;
  dynamic price;
  dynamic createdBy;
  dynamic updatedBy;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  int ticketCount;
  Category? category;
  List<Ride>? rides;

  ZoneTickets({
    this.id,
    this.parkId,
    this.branchId,
    this.rideId,
    this.name,
    this.ticketCategoryId,
    this.price,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.ticketCount,
    this.category,
    this.rides,

  });

  factory ZoneTickets.fromJson(Map<String, dynamic> json) => ZoneTickets(
        id: json["id"],
        parkId: json["park_id"],
        branchId: json["branch_id"],
        rideId: json["ride_id"],
        name: json["name"],
        ticketCategoryId: json["ticket_category_id"],
        price: json["price"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json[
            "created_at"], //== null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json[
            "updated_at"], //== null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"], ticketCount: 0,
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
    rides: json["rides"] == null ? [] : List<Ride>.from(json["rides"]!.map((x) => Ride.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "park_id": parkId,
        "branch_id": branchId,
        "ride_id": rideId,
        "name": name,
        "ticket_category_id": ticketCategoryId,
        "price": price,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt, //?.toIso8601String(),
        "updated_at": updatedAt, //?.toIso8601String(),
        "deleted_at": deletedAt,
        "category": category?.toJson(),
    "rides": rides == null ? [] : List<dynamic>.from(rides!.map((x) => x.toJson())),

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

class Ride {
  int? id;
  int? ticketId;
  int? rideId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? ride;

  Ride({
    this.id,
    this.ticketId,
    this.rideId,
    this.createdAt,
    this.updatedAt,
    this.ride,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
    id: json["id"],
    ticketId: json["ticket_id"],
    rideId: json["ride_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    ride: json["ride"] == null ? null : Category.fromJson(json["ride"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_id": ticketId,
    "ride_id": rideId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "ride": ride?.toJson(),
  };
}
