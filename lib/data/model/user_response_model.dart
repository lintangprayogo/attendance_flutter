import 'dart:convert';

class UserResponseModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String position;
  final String department;
  final String? faceEmbedding;
  final String? imageUrl;

  UserResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.position,
    required this.department,
    required this.faceEmbedding,
    required this.imageUrl,
  });

  factory UserResponseModel.fromJson(String str) =>
      UserResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserResponseModel.fromMap(Map<String, dynamic> json) =>
      UserResponseModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        role: json['role'],
        position: json['position'],
        department: json['department'],
        faceEmbedding: json['face_embedding'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'position': position,
        'department': department,
        'face_embedding': faceEmbedding,
        'image_url': imageUrl,
      };
}
