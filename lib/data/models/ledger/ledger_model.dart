// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Ledger {
  String id;
  String name;
  String printName;
  String aliasName;
  String ledgerGroup;
  String date;
  String bilwiseAccounting;
  int creditDays;
  double openingBalance;
  double debitBalance;
  String ledgerType;
  String priceListCategory;
  String remarks;
  String status;
  int ledgerCode;
  String mailingName;
  String address;
  String city;
  String region;
  String state;
  int pincode;
  int tel;
  int fax;
  int mobile;
  int sms;
  String email;
  String contactPerson;
  String bankName;
  String branchName;
  String ifsc;
  String accName;
  String accNo;
  String panNo;
  String gst;
  String gstDated;
  String cstNo;
  String cstDated;
  String lstNo;
  String lstDated;
  String serviceTaxNo;
  String serviceTaxDated;
  String registrationType;
  String registrationTypeDated;
  Ledger({
    required this.id,
    required this.name,
    required this.printName,
    required this.aliasName,
    required this.ledgerGroup,
    required this.date,
    required this.bilwiseAccounting,
    required this.creditDays,
    required this.openingBalance,
    required this.debitBalance,
    required this.ledgerType,
    required this.priceListCategory,
    required this.remarks,
    required this.status,
    required this.ledgerCode,
    required this.mailingName,
    required this.address,
    required this.city,
    required this.region,
    required this.state,
    required this.pincode,
    required this.tel,
    required this.fax,
    required this.mobile,
    required this.sms,
    required this.email,
    required this.contactPerson,
    required this.bankName,
    required this.branchName,
    required this.ifsc,
    required this.accName,
    required this.accNo,
    required this.panNo,
    required this.gst,
    required this.gstDated,
    required this.cstNo,
    required this.cstDated,
    required this.lstNo,
    required this.lstDated,
    required this.serviceTaxNo,
    required this.serviceTaxDated,
    required this.registrationType,
    required this.registrationTypeDated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'printName': printName,
      'aliasName': aliasName,
      'ledgerGroup': ledgerGroup,
      'date': date,
      'bilwiseAccounting': bilwiseAccounting,
      'creditDays': creditDays,
      'openingBalance': openingBalance,
      'debitBalance': debitBalance,
      'ledgerType': ledgerType,
      'priceListCategory': priceListCategory,
      'remarks': remarks,
      'status': status,
      'ledgerCode': ledgerCode,
      'mailingName': mailingName,
      'address': address,
      'city': city,
      'region': region,
      'state': state,
      'pincode': pincode,
      'tel': tel,
      'fax': fax,
      'mobile': mobile,
      'sms': sms,
      'email': email,
      'contactPerson': contactPerson,
      'bankName': bankName,
      'branchName': branchName,
      'ifsc': ifsc,
      'accName': accName,
      'accNo': accNo,
      'panNo': panNo,
      'gst': gst,
      'gstDated': gstDated,
      'cstNo': cstNo,
      'cstDated': cstDated,
      'lstNo': lstNo,
      'lstDated': lstDated,
      'serviceTaxNo': serviceTaxNo,
      'serviceTaxDated': serviceTaxDated,
      'registrationType': registrationType,
      'registrationTypeDated': registrationTypeDated,
    };
  }

  factory Ledger.fromMap(Map<String, dynamic> map) {
    return Ledger(
      id: map['_id'] as String,
      name: map['name'] as String,
      printName: map['printName'] as String,
      aliasName: map['aliasName'] as String,
      ledgerGroup: map['ledgerGroup'] as String,
      date: map['date'] as String,
      bilwiseAccounting: map['bilwiseAccounting'] as String,
      creditDays: map['creditDays'] as int,
      openingBalance: map['openingBalance'] as double,
      debitBalance: map['debitBalance'] as double,
      ledgerType: map['ledgerType'] as String,
      priceListCategory: map['priceListCategory'] as String,
      remarks: map['remarks'] as String,
      status: map['status'] as String,
      ledgerCode: map['ledgerCode'] as int,
      mailingName: map['mailingName'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      region: map['region'] as String,
      state: map['state'] as String,
      pincode: map['pincode'] as int,
      tel: map['tel'] as int,
      fax: map['fax'] as int,
      mobile: map['mobile'] as int,
      sms: map['sms'] as int,
      email: map['email'] as String,
      contactPerson: map['contactPerson'] as String,
      bankName: map['bankName'] as String,
      branchName: map['branchName'] as String,
      ifsc: map['ifsc'] as String,
      accName: map['accName'] as String,
      accNo: map['accNo'] as String,
      panNo: map['panNo'] as String,
      gst: map['gst'] as String,
      gstDated: map['gstDated'] as String,
      cstNo: map['cstNo'] as String,
      cstDated: map['cstDated'] as String,
      lstNo: map['lstNo'] as String,
      lstDated: map['lstDated'] as String,
      serviceTaxNo: map['serviceTaxNo'] as String,
      serviceTaxDated: map['serviceTaxDated'] as String,
      registrationType: map['registrationType'] as String,
      registrationTypeDated: map['registrationTypeDated'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ledger.fromJson(String source) =>
      Ledger.fromMap(json.decode(source) as Map<String, dynamic>);
}
