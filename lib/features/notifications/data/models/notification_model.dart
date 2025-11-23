import 'package:hive/hive.dart';

part 'notification_model.g.dart';

enum NotificationType {
  order,
  promotion,
  prescription,
  consultation,
  general,
}

@HiveType(typeId: 13)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final NotificationType type;

  @HiveField(4)
  final bool isRead;

  @HiveField(5)
  final String? relatedId;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final Map<String, dynamic>? data;

  @HiveField(8)
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.relatedId,
    this.imageUrl,
    this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.general,
      ),
      isRead: json['is_read'] as bool? ?? false,
      relatedId: json['related_id'] as String?,
      imageUrl: json['image_url'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'is_read': isRead,
      'related_id': relatedId,
      'image_url': imageUrl,
      'data': data,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    String? relatedId,
    String? imageUrl,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
