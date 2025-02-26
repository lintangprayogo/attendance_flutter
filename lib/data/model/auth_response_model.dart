import 'dart:convert';

import 'user.dart';

class AuthResponseModel {
  final String message;
  final String accessToken;
  final User user;

  AuthResponseModel({
    required this.message,
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        message: json['message'],
        accessToken: json['access_token'],
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'access_token': accessToken,
        'user': user.toJson(),
      };
}
