import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StoreModel {
  final String? code;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final String bankName;
  final String branch;
  final String accountNo;
  final String accountName;
  final String upi;
  final String ifsc;
  final String status;
  final String email;
  final String password;
  StoreModel({
    this.code,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    required this.bankName,
    required this.branch,
    required this.accountNo,
    required this.accountName,
    required this.upi,
    required this.ifsc,
    required this.status,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code ?? '',
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phone': phone,
      'bankName': bankName,
      'branch': branch,
      'accountNo': accountNo,
      'accountName': accountName,
      'upi': upi,
      'ifsc': ifsc,
      'status': status,
      'email': email,
      'password': password,
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      code: map['code'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      pincode: map['pincode'] as String,
      phone: map['phone'] as String,
      bankName: map['bankName'] as String,
      branch: map['branch'] as String,
      accountNo: map['accountNo'] as String,
      accountName: map['accountName'] as String,
      upi: map['upi'] as String,
      ifsc: map['ifsc'] as String,
      status: map['status'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source) as Map<String, dynamic>);
}


