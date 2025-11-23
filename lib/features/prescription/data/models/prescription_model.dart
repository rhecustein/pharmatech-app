import 'package:hive/hive.dart';

part 'prescription_model.g.dart';

enum PrescriptionStatus {
  pending,
  approved,
  rejected,
}

@HiveType(typeId: 8)
class PrescriptionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String prescriptionNumber;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String doctorName;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final PrescriptionStatus status;

  @HiveField(6)
  final String? apotekerId;

  @HiveField(7)
  final String? apotekerName;

  @HiveField(8)
  final String? apotekerNotes;

  @HiveField(9)
  final List<PrescriptionMedicineModel>? medicines;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  @HiveField(12)
  final DateTime? approvedAt;

  PrescriptionModel({
    required this.id,
    required this.prescriptionNumber,
    required this.imageUrl,
    required this.doctorName,
    this.notes,
    required this.status,
    this.apotekerId,
    this.apotekerName,
    this.apotekerNotes,
    this.medicines,
    required this.createdAt,
    required this.updatedAt,
    this.approvedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      prescriptionNumber: json['prescription_number'] as String,
      imageUrl: json['image_url'] as String,
      doctorName: json['doctor_name'] as String,
      notes: json['notes'] as String?,
      status: PrescriptionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      apotekerId: json['apoteker_id'] as String?,
      apotekerName: json['apoteker_name'] as String?,
      apotekerNotes: json['apoteker_notes'] as String?,
      medicines: json['medicines'] != null
          ? (json['medicines'] as List<dynamic>)
              .map((e) => PrescriptionMedicineModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescription_number': prescriptionNumber,
      'image_url': imageUrl,
      'doctor_name': doctorName,
      'notes': notes,
      'status': status.toString().split('.').last,
      'apoteker_id': apotekerId,
      'apoteker_name': apotekerName,
      'apoteker_notes': apotekerNotes,
      'medicines': medicines?.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
    };
  }
}

@HiveType(typeId: 9)
class PrescriptionMedicineModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String dosage;

  @HiveField(3)
  final String frequency;

  @HiveField(4)
  final int duration;

  @HiveField(5)
  final String? notes;

  PrescriptionMedicineModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.notes,
  });

  factory PrescriptionMedicineModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'notes': notes,
    };
  }
}

class UploadPrescriptionRequest {
  final String imagePath;
  final String doctorName;
  final String? notes;

  UploadPrescriptionRequest({
    required this.imagePath,
    required this.doctorName,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor_name': doctorName,
      'notes': notes,
    };
  }
}
