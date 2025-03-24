import 'package:meta/meta.dart';
import 'dart:convert';

class CompanyResponseModel {
    final int id;
    final String name;
    final String email;
    final String address;
    final String longitude;
    final String latitude;
    final String radiusKm;
    final String timeIn;
    final String timeOut;
    final DateTime createdAt;
    final DateTime updatedAt;

    CompanyResponseModel({
        required this.id,
        required this.name,
        required this.email,
        required this.address,
        required this.longitude,
        required this.latitude,
        required this.radiusKm,
        required this.timeIn,
        required this.timeOut,
        required this.createdAt,
        required this.updatedAt,
    });


    String toJson() => json.encode(toJson());

    factory CompanyResponseModel.fromMap(Map<String, dynamic> json) => CompanyResponseModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        address: json['address'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        radiusKm: json['radius_km'],
        timeIn: json['time_in'],
        timeOut: json['time_out'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
    );


}
