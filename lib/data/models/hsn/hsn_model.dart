// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HSNCode {
  String id;
  String hsn;
  String unit;
  String description;
  DateTime updatedOn;
  DateTime createdOn;

  HSNCode({
    required this.id,
    required this.hsn,
    required this.unit,
    required this.description,
    required this.updatedOn,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hsn': hsn,
      'unit': unit,
      'description': description,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory HSNCode.fromMap(Map<String, dynamic> map) {
    return HSNCode(
      id: map['_id'] ?? '',
      hsn: map['hsn'] ?? '',
      unit: map['unit'] ?? '',
      description: map['description'] ?? '',
      updatedOn: DateTime.parse(map['updatedOn']),
      createdOn: DateTime.parse(map['createdOn']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HSNCode.fromJson(String source) =>
      HSNCode.fromMap(json.decode(source) as Map<String, dynamic>);
}
