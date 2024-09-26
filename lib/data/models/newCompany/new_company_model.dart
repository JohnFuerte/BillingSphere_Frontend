import 'dart:convert';
import 'dart:typed_data';

import 'store_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewCompany {
  final String id;
  String? companyName;
  String? companyCode;
  String? companyType;
  String? country;
  String? tagline;
  String? lstNo;
  String? cstNo;
  String? gstin;
  String? signatory;
  String? designation;
  String? pan;
  String? ewayBill;
  String? caching;
  String? taxation;
  String? acYear;
  String? acYearTo;
  String? tc1;
  String? tc2;
  String? tc3;
  String? tc4;
  String? tc5;
  String? email;
  String? password;
  List<ImageData>? logo1;
  List<ImageData>? logo2;
  List<ImageData>? signature;
  List<StoreModel>? stores;
  NewCompany({
    required this.id,
    required this.companyName,
    this.companyCode,
    required this.companyType,
    required this.country,
    this.tagline,
    this.lstNo,
    this.cstNo,
    this.gstin,
    this.signatory,
    this.designation,
    this.pan,
    this.ewayBill,
    this.caching,
    this.tc1,
    this.tc2,
    this.tc3,
    this.tc4,
    this.tc5,
    required this.taxation,
    required this.acYear,
    required this.acYearTo,
    required this.password,
    required this.email,
    this.logo1,
    this.logo2,
    this.signature,
    this.stores,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'companyName': companyName,
      'companyCode': companyCode ?? "",
      'companyType': companyType,
      'country': country,
      'tagline': tagline ?? "",
      'lstNo': lstNo ?? "",
      'cstNo': cstNo ?? "",
      'gstin': gstin ?? "",
      'signatory': signatory ?? "",
      'email': email ?? "",
      'designation': designation ?? "",
      'pan': pan ?? "",
      'ewayBill': ewayBill ?? "",
      'caching': caching ?? "",
      'taxation': taxation,
      'acYear': acYear,
      'acYearTo': acYearTo,
      'tc1': tc1 ?? "",
      'tc2': tc2 ?? "",
      'tc3': tc3 ?? "",
      'tc4': tc4 ?? "",
      'tc5': tc5 ?? "",
      'password': password,
      'logo1': logo1?.map((image) => image.toJson()).toList() ?? [],
      'logo2': logo2?.map((image) => image.toJson()).toList() ?? [],
      'signature': signature?.map((image) => image.toJson()).toList() ?? [],
      'stores': stores?.map((store) => store.toMap()).toList() ?? [],
    };
  }

  factory NewCompany.fromMap(Map<String, dynamic> map) {
    return NewCompany(
      id: map['_id'] as String,
      companyName: map['companyName'] as String,
      companyCode:
          map['companyCode'] != null ? map['companyCode'] as String : "",
      companyType: map['companyType'] as String,
      country: map['country'] as String,
      tagline: map['tagline'] != null ? map['tagline'] as String : "",
      lstNo: map['lstNo'] != null ? map['lstNo'] as String : "",
      cstNo: map['cstNo'] != null ? map['cstNo'] as String : "",
      gstin: map['gstin'] != null ? map['gstin'] as String : "",
      signatory: map['signatory'] != null ? map['signatory'] as String : "",
      designation:
          map['designation'] != null ? map['designation'] as String : "",
      pan: map['pan'] != null ? map['pan'] as String : "",
      ewayBill: map['ewayBill'] != null ? map['ewayBill'] as String : "",
      caching: map['caching'] != null ? map['caching'] as String : "",
      taxation: map['taxation'] as String,
      acYear: map['acYear'] as String,
      acYearTo: map['acYearTo'] as String,
      tc1: map['tc1'] != null ? map['tc1'] as String : "",
      tc2: map['tc2'] != null ? map['tc2'] as String : "",
      tc3: map['tc3'] != null ? map['tc3'] as String : "",
      tc4: map['tc4'] != null ? map['tc4'] as String : "",
      tc5: map['tc5'] != null ? map['tc5'] as String : "",
      password: map['password'] as String,
      email: map['email'] as String,
      logo1: (map['logo1'] as List<dynamic>?)
              ?.map<ImageData>((dynamic json) =>
                  ImageData.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [],
      logo2: (map['logo2'] as List<dynamic>?)
              ?.map<ImageData>((dynamic json) =>
                  ImageData.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [],
      signature: (map['signature'] as List<dynamic>?)
              ?.map<ImageData>((dynamic json) =>
                  ImageData.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [],
      stores: (map['stores'] as List<dynamic>?)
              ?.map<StoreModel>((dynamic json) =>
                  StoreModel.fromMap(json as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory NewCompany.fromJson(String source) =>
      NewCompany.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ImageData {
  final Uint8List data;
  final String contentType;
  final String filename;

  ImageData({
    required this.data,
    required this.contentType,
    required this.filename,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      data: Uint8List.fromList(List<int>.from(json['data']['data'])),
      contentType: json['contentType'],
      filename: json['filename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': base64.encode(data),
      'contentType': contentType,
      'filename': filename,
    };
  }
}
