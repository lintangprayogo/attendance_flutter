import 'dart:convert';

import 'user.dart';

class AuthResponseModel {
  final String token;
  final User user;

  AuthResponseModel({
    required this.token,
    required this.user,
  });

  AuthResponseModel copyWith({
    User? user,
    String? token,
  }) {
    return AuthResponseModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        token: json['access_token'],
        user: User.fromMap(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'access_token': token,
        'user': user.toMap(),
      };
}
