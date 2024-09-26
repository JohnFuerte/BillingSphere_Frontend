// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class Sundry {
  String id;
  String sundryName;
  int sundryAmount;
  Sundry({
    required this.id,
    required this.sundryName,
    required this.sundryAmount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sundryName': sundryName,
      'sundryAmount': sundryAmount,
    };
  }

  factory Sundry.fromMap(Map<String, dynamic> map) {
    return Sundry(
      id: map['_id'] as String,
      sundryName: map['sundryName'] as String,
      sundryAmount: map['sundryAmount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sundry.fromJson(String source) =>
      Sundry.fromMap(json.decode(source) as Map<String, dynamic>);
}
