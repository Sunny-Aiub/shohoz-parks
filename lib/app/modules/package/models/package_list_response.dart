// To parse this JSON data, do
//
//     final packageListResponse = packageListResponseFromJson(jsonString);

import 'dart:convert';

PackageListResponse packageListResponseFromJson(String str) => PackageListResponse.fromJson(json.decode(str));

String packageListResponseToJson(PackageListResponse data) => json.encode(data.toJson());

class PackageListResponse {
  List<PackageDatum>? data;
  String? message;

  PackageListResponse({
    this.data,
    this.message,
  });

  factory PackageListResponse.fromJson(Map<String, dynamic> json) => PackageListResponse(
    data: json["data"] == null ? [] : List<PackageDatum>.from(json["data"]!.map((x) => PackageDatum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class PackageDatum {
  int? id;
  dynamic? branchId;
  dynamic? parkId;
  String? name;
  String? description;
  String? banner;
  dynamic? price;
  DateTime? startDate;
  DateTime? endDate;
  dynamic? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Branch? park;
  Branch? branch;
  List<PackageTicket>? rideTickets;
  List<PackageTicket>? entryTickets;

  int ticketCount = 0;

  PackageDatum({
    this.id,
    this.branchId,
    this.parkId,
    this.name,
    this.description,
    this.banner,
    this.price,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.park,
    this.branch,
    this.rideTickets,
    this.entryTickets, required this.ticketCount,
  });

  factory PackageDatum.fromJson(Map<String, dynamic> json) => PackageDatum(
    id: json["id"],
    branchId: json["branch_id"],
    parkId: json["park_id"],
    name: json["name"],
    description: json["description"],
    banner: json["banner"],
    price: json["price"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    status: json["status"],
    createdAt: json["created_at"]  ,
    updatedAt: json["updated_at"]  ,
    deletedAt: json["deleted_at"],
    park: json["park"] == null ? null : Branch.fromJson(json["park"]),
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
    rideTickets: json["ride_tickets"] == null ? [] : List<PackageTicket>.from(json["ride_tickets"]!.map((x) => PackageTicket.fromJson(x))),
    entryTickets: json["entry_tickets"] == null ? [] : List<PackageTicket>.from(json["entry_tickets"]!.map((x) => PackageTicket.fromJson(x))), ticketCount: 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_id": branchId,
    "park_id": parkId,
    "name": name,
    "description": description,
    "banner": banner,
    "price": price,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "status": status,
    "created_at": createdAt ,
    "updated_at": updatedAt ,
    "deleted_at": deletedAt,
    "park": park?.toJson(),
    "branch": branch?.toJson(),
    "ride_tickets": rideTickets == null ? [] : List<dynamic>.from(rideTickets!.map((x) => x.toJson())),
    "entry_tickets": entryTickets == null ? [] : List<dynamic>.from(entryTickets!.map((x) => x.toJson())),
  };
}

class Branch {
  dynamic? id;
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

class PackageTicket {
  dynamic? id;
  dynamic? parkId;
  dynamic? branchId;
  dynamic? entryTicketTypeId;
  String? name;
  dynamic? price;
  dynamic duration;
  dynamic? createdBy;
  dynamic? updatedBy;
  dynamic deviceId;
  dynamic? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? laravelThroughKey;
  dynamic? rideId;
  dynamic? ticketCategoryId;
  Ride? ride;

  PackageTicket({
    this.id,
    this.parkId,
    this.branchId,
    this.entryTicketTypeId,
    this.name,
    this.price,
    this.duration,
    this.createdBy,
    this.updatedBy,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,

    this.rideId,
    this.ticketCategoryId,
    this.ride,
  });

  factory PackageTicket.fromJson(Map<String, dynamic> json) => PackageTicket(
    id: json["id"],
    parkId: json["park_id"],
    branchId: json["branch_id"],
    entryTicketTypeId: json["entry_ticket_type_id"],
    name: json["name"],
    price: json["price"],
    duration: json["duration"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deviceId: json["device_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],

    rideId: json["ride_id"],
    ticketCategoryId: json["ticket_category_id"],
    ride: json["ride"] == null ? null : Ride.fromJson(json["ride"]),
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
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,

    "ride_id": rideId,
    "ticket_category_id": ticketCategoryId,
    "ride": ride?.toJson(),
  };
}

class Ride {
  dynamic? id;
  dynamic? parkId;
  dynamic? branchId;
  String? name;
  String? logo;
  String? description;
  dynamic? createdBy;
  dynamic? updatedBy;
  dynamic deviceId;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Ride({
    this.id,
    this.parkId,
    this.branchId,
    this.name,
    this.logo,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
    id: json["id"],
    parkId: json["park_id"],
    branchId: json["branch_id"],
    name: json["name"],
    logo: json["logo"],
    description: json["description"],
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
    "park_id": parkId,
    "branch_id": branchId,
    "name": name,
    "logo": logo,
    "description": description,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}
