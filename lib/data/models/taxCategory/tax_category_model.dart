// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaxRate {
  String id;
  String rate;
  DateTime updatedOn;
  DateTime createdOn;

  TaxRate({
    required this.id,
    required this.rate,
    required this.updatedOn,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rate': rate,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory TaxRate.fromMap(Map<String, dynamic> map) {
    return TaxRate(
      id: map['_id'],
      rate: map['rate'],
      updatedOn: DateTime.parse(map['updatedOn'].toString()),
      createdOn: DateTime.parse(map['createdOn'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaxRate.fromJson(String source) =>
      TaxRate.fromMap(json.decode(source) as Map<String, dynamic>);
}
