import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SalesMan {
  String id;
  String name;
  String ledger;
  String? postInAc;
  double? fixedCommission;
  String? address;
  String? mobile;
  String? email;
  String? isActive;
  SalesMan({
    required this.id,
    required this.name,
    required this.ledger,
    this.postInAc,
    this.fixedCommission,
    this.address,
    this.mobile,
    this.email,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ledger': ledger,
      'postInAc': postInAc,
      'fixedCommission': fixedCommission,
      'address': address,
      'mobile': mobile,
      'email': email,
      'isActive': isActive,
    };
  }

  factory SalesMan.fromMap(Map<String, dynamic> map) {
    return SalesMan(
      id: map['_id'] as String,
      name: map['name'] as String,
      ledger: map['ledger'] as String,
      postInAc: map['postInAc'] != null ? map['postInAc'] as String : null,
      fixedCommission: map['fixedCommission'] != null
          ? map['fixedCommission'] as double
          : null,
      address: map['address'] != null ? map['address'] as String : null,
      mobile: map['mobile'] != null ? map['mobile'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesMan.fromJson(String source) =>
      SalesMan.fromMap(json.decode(source) as Map<String, dynamic>);
}
