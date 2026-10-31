// To parse this JSON data, do
//
//     final medicalRecord = medicalRecordFromJson(jsonString);

import 'dart:convert';

List<MedicalRecord> medicalRecordFromJson(String str) => List<MedicalRecord>.from(json.decode(str).map((x) => MedicalRecord.fromJson(x)));

String medicalRecordToJson(List<MedicalRecord> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MedicalRecord {
    final String description;
    final int id;
    final String doctorName;
    final DateTime recordDate;
    final int userId;
    final String title;

    MedicalRecord({
        required this.description,
        required this.id,
        required this.doctorName,
        required this.recordDate,
        required this.userId,
        required this.title,
    });

    factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        description: json["description"],
        id: json["id"],
        doctorName: json["doctor_name"],
        recordDate: DateTime.parse(json["record_date"]),
        userId: json["user_id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "doctor_name": doctorName,
        "record_date": "${recordDate.year.toString().padLeft(4, '0')}-${recordDate.month.toString().padLeft(2, '0')}-${recordDate.day.toString().padLeft(2, '0')}",
        "user_id": userId,
        "title": title,
    };
}
