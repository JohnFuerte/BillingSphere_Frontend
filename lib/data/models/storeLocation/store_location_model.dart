// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreLocation {
  String id;
  String location;
  DateTime updatedOn;
  DateTime createdOn;

  StoreLocation({
    required this.id,
    required this.location,
    required this.updatedOn,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'location': location,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory StoreLocation.fromMap(Map<String, dynamic> map) {
    return StoreLocation(
      id: map['_id'] as String,
      location: map['location'] as String,
      updatedOn: DateTime.parse(map['updatedOn']),
      createdOn: DateTime.parse(map['createdOn']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreLocation.fromJson(String source) =>
      StoreLocation.fromMap(json.decode(source) as Map<String, dynamic>);
}
