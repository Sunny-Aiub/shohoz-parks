// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    Data? data;
    List<String>? password;
    List<String>? phone;
    String? message;

    LoginResponse({
        this.data,
        this.password,
        this.phone,
        this.message,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        password: json["password"] == null ? [] : List<String>.from(json["password"]!.map((x) => x)),
        phone: json["phone"] == null ? [] : List<String>.from(json["phone"]!.map((x) => x)),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "password": password == null ? [] : List<dynamic>.from(password!.map((x) => x)),
        "phone": phone == null ? [] : List<dynamic>.from(phone!.map((x) => x)),
        "message": message,
    };
}

class Data {
    User? user;
    List<String>? roles;
    List<Ride>? rides;
    String? token;

    Data({
        this.user,
        this.roles,
        this.rides,
        this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
        rides: json["rides"] == null ? [] : List<Ride>.from(json["rides"]!.map((x) => Ride.fromJson(x))),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
        "rides": rides == null ? [] : List<dynamic>.from(rides!.map((x) => x.toJson())),
        "token": token,
    };
}

class Ride {
    int? id;
    String? name;

    Ride({
        this.id,
        this.name,
    });

    factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
class User {
    String? firstName;
    String? lastName;

  String? phone;

    User({
        this.firstName,
        this.lastName,this.phone
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
    };
}
