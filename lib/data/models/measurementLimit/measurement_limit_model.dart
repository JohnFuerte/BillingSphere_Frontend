// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MeasurementLimit {
  String id;
  String measurement;
  DateTime updatedOn;
  DateTime createdOn;

  MeasurementLimit({
    required this.id,
    required this.measurement,
    required this.updatedOn,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'measurement': measurement,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory MeasurementLimit.fromMap(Map<String, dynamic> map) {
    return MeasurementLimit(
      id: map['_id'] as String,
      measurement: map['measurement'] as String,
      updatedOn: map['updatedOn'] != null
          ? DateTime.tryParse(map['updatedOn'] as String) ?? DateTime.now()
          : DateTime.now(),
      createdOn: map['createdOn'] != null
          ? DateTime.tryParse(map['createdOn'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeasurementLimit.fromJson(String source) =>
      MeasurementLimit.fromMap(json.decode(source) as Map<String, dynamic>);
}
