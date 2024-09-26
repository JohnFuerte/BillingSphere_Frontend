import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LedgerGroup {
  String id;
  String name;

  LedgerGroup({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory LedgerGroup.fromMap(Map<String, dynamic> map) {
    return LedgerGroup(
      id: map['_id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LedgerGroup.fromJson(String source) =>
      LedgerGroup.fromMap(json.decode(source) as Map<String, dynamic>);
}
