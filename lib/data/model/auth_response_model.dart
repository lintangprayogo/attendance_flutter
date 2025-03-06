import 'dart:convert';

import 'user_response_model.dart';

class AuthResponseModel {
  final String token;
  final UserResponseModel user;

  AuthResponseModel({
    required this.token,
    required this.user,
  });

  AuthResponseModel copyWith({
    UserResponseModel? user,
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
        user: UserResponseModel.fromMap(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'access_token': token,
        'user': user.toMap(),
      };
}
