// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SecondaryUnit {
  String id;
  String secondaryUnit;
  DateTime updatedOn;
  DateTime createdOn;

  SecondaryUnit({
    required this.id,
    required this.secondaryUnit,
    required this.updatedOn,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'secondaryUnit': secondaryUnit,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory SecondaryUnit.fromMap(Map<String, dynamic> map) {
    return SecondaryUnit(
      id: map['_id'] as String,
      secondaryUnit: map['secondaryUnit'] as String,
      updatedOn: map['updatedOn'] != null
          ? DateTime.tryParse(map['updatedOn'] as String) ?? DateTime.now()
          : DateTime.now(),
      createdOn: map['createdOn'] != null
          ? DateTime.tryParse(map['createdOn'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondaryUnit.fromJson(String source) =>
      SecondaryUnit.fromMap(json.decode(source) as Map<String, dynamic>);
}
