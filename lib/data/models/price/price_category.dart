// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PriceCategory {
  final String id;
  final String companyCode;
  final String priceCategoryType;
  final String? updatedOn;
  final String? createdOn;

  PriceCategory({
    required this.id,
    required this.companyCode,
    required this.priceCategoryType,
    this.updatedOn,
    this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'companyCode': companyCode,
      'priceCategoryType': priceCategoryType,
      'updatedOn': updatedOn,
      'createdOn': createdOn,
    };
  }

  factory PriceCategory.fromMap(Map<String, dynamic> map) {
    return PriceCategory(
      id: map['_id'] as String,
      companyCode: map['companyCode'] as String,
      priceCategoryType: map['priceCategoryType'] as String,
      updatedOn: map['updatedOn'] != null ? map['updatedOn'] as String : null,
      createdOn: map['createdOn'] != null ? map['createdOn'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceCategory.fromJson(String source) =>
      PriceCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}
