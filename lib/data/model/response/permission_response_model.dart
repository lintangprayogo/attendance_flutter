

class PermissionResponseModel {
     final int userId;
    final DateTime datePermission;
    final String reason;
    final int isApproved;
    final String image;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int id;

    PermissionResponseModel({
        required this.userId,
        required this.datePermission,
        required this.reason,
        required this.isApproved,
        required this.image,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

  
    factory PermissionResponseModel.fromMap(Map<String, dynamic> json) => PermissionResponseModel(
        userId: json['user_id'],
        datePermission: DateTime.parse(json['date_permission']),
        reason: json['reason'],
        isApproved: json['is_approved'],
        image: json['image'],
        updatedAt: DateTime.parse(json['updated_at']),
        createdAt: DateTime.parse(json['created_at']),
        id: json['id'],
    );

}