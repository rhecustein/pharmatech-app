import 'package:hive/hive.dart';

part 'consultation_model.g.dart';

enum PharmacistStatus {
  online,
  offline,
  busy,
}

enum ConsultationType {
  chat,
  videoCall,
}

@HiveType(typeId: 10)
class PharmacistModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? avatar;

  @HiveField(3)
  final String licenseNumber;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final int reviewCount;

  @HiveField(6)
  final int yearsOfExperience;

  @HiveField(7)
  final String? specialization;

  @HiveField(8)
  final PharmacistStatus status;

  @HiveField(9)
  final bool isAvailable;

  PharmacistModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.licenseNumber,
    required this.rating,
    required this.reviewCount,
    required this.yearsOfExperience,
    this.specialization,
    required this.status,
    this.isAvailable = true,
  });

  factory PharmacistModel.fromJson(Map<String, dynamic> json) {
    return PharmacistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      licenseNumber: json['license_number'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      yearsOfExperience: json['years_of_experience'] as int,
      specialization: json['specialization'] as String?,
      status: PharmacistStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'license_number': licenseNumber,
      'rating': rating,
      'review_count': reviewCount,
      'years_of_experience': yearsOfExperience,
      'specialization': specialization,
      'status': status.toString().split('.').last,
      'is_available': isAvailable,
    };
  }
}

@HiveType(typeId: 11)
class ConsultationSessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pharmacistId;

  @HiveField(2)
  final PharmacistModel pharmacist;

  @HiveField(3)
  final ConsultationType type;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final DateTime startedAt;

  @HiveField(6)
  final DateTime? endedAt;

  @HiveField(7)
  final List<ChatMessageModel> messages;

  ConsultationSessionModel({
    required this.id,
    required this.pharmacistId,
    required this.pharmacist,
    required this.type,
    this.isActive = true,
    required this.startedAt,
    this.endedAt,
    this.messages = const [],
  });

  factory ConsultationSessionModel.fromJson(Map<String, dynamic> json) {
    return ConsultationSessionModel(
      id: json['id'] as String,
      pharmacistId: json['pharmacist_id'] as String,
      pharmacist: PharmacistModel.fromJson(
        json['pharmacist'] as Map<String, dynamic>,
      ),
      type: ConsultationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      isActive: json['is_active'] as bool? ?? true,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List<dynamic>)
              .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pharmacist_id': pharmacistId,
      'pharmacist': pharmacist.toJson(),
      'type': type.toString().split('.').last,
      'is_active': isActive,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}

enum MessageType {
  text,
  image,
  file,
}

@HiveType(typeId: 12)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sessionId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final bool isFromUser;

  @HiveField(4)
  final MessageType type;

  @HiveField(5)
  final String content;

  @HiveField(6)
  final String? fileUrl;

  @HiveField(7)
  final String? fileName;

  @HiveField(8)
  final bool isRead;

  @HiveField(9)
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.sessionId,
    required this.senderId,
    required this.isFromUser,
    this.type = MessageType.text,
    required this.content,
    this.fileUrl,
    this.fileName,
    this.isRead = false,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      senderId: json['sender_id'] as String,
      isFromUser: json['is_from_user'] as bool,
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      content: json['content'] as String,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'sender_id': senderId,
      'is_from_user': isFromUser,
      'type': type.toString().split('.').last,
      'content': content,
      'file_url': fileUrl,
      'file_name': fileName,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SendMessageRequest {
  final String sessionId;
  final MessageType type;
  final String content;
  final String? filePath;

  SendMessageRequest({
    required this.sessionId,
    this.type = MessageType.text,
    required this.content,
    this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'type': type.toString().split('.').last,
      'content': content,
    };
  }
}

class StartConsultationRequest {
  final String pharmacistId;
  final ConsultationType type;

  StartConsultationRequest({
    required this.pharmacistId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'pharmacist_id': pharmacistId,
      'type': type.toString().split('.').last,
    };
  }
}
