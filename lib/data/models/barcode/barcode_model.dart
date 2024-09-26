import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Barcode {
  String id;
  String barcode;
  Barcode({
    required this.id,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'barcode': barcode,
    };
  }

  factory Barcode.fromMap(Map<String, dynamic> map) {
    return Barcode(
      id: map['_id'] as String,
      barcode: map['barcode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Barcode.fromJson(String source) =>
      Barcode.fromMap(json.decode(source) as Map<String, dynamic>);
}
