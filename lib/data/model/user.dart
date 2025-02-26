import 'dart:convert';

class User {
    final int id;
    final String name;
    final String email;
    final String phone;
    final String role;
    final String position;
    final String department;
    final String? faceEmbedding;
    final String? imageUrl;

    User({
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

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
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

    Map<String, dynamic> toJson() => {
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
