import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewCustomerModel {
  final String id;
  final String mobile;
  final String fname;
  final String? lname;
  final String? mname;
  final String? fullname;
  final String? sms;
  final String? customerType;
  final String? customerId;
  final String? address;
  final String? city;
  final String? aadharCard;
  final String? email;
  final String? birthdate;
  final String? isActive;
  NewCustomerModel({
    required this.id,
    required this.mobile,
    required this.fname,
    this.lname,
    this.mname,
    this.fullname,
    this.sms,
    this.customerType,
    this.customerId,
    this.address,
    this.city,
    this.aadharCard,
    this.email,
    this.birthdate,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'mobile': mobile,
      'fname': fname,
      'lname': lname,
      'mname': mname,
      'fullname': fullname,
      'sms': sms,
      'customerType': customerType,
      'customerId': customerId,
      'address': address,
      'city': city,
      'aadharCard': aadharCard,
      'email': email,
      'birthdate': birthdate,
      'isActive': isActive,
    };
  }

  factory NewCustomerModel.fromMap(Map<String, dynamic> map) {
    return NewCustomerModel(
      id: map['_id'] as String,
      mobile: map['mobile'] as String,
      fname: map['fname'] as String,
      lname: map['lname'] != null ? map['lname'] as String : null,
      mname: map['mname'] != null ? map['mname'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      sms: map['sms'] != null ? map['sms'] as String : null,
      customerType:
          map['customerType'] != null ? map['customerType'] as String : null,
      customerId:
          map['customerId'] != null ? map['customerId'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      aadharCard:
          map['aadharCard'] != null ? map['aadharCard'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      birthdate: map['birthdate'] != null ? map['birthdate'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewCustomerModel.fromJson(String source) =>
      NewCustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
