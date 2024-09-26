// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NUserModel {
  String? sId;
  String? fullName;
  String? email;
  String? password;
  String? hintpassword;
  String? id;
  String? updatedOn;
  String? token;
  List<String>? companies;
  String? userGroup;
  String? dashboardAccess;
  String? dashboardCategory;
  String? backDateEntry;

  NUserModel({
    this.sId,
    this.fullName,
    this.email,
    this.password,
    this.hintpassword,
    this.id,
    this.updatedOn,
    this.companies,
    this.userGroup,
    this.dashboardAccess,
    this.dashboardCategory,
    this.backDateEntry,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sId': sId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'hintpassword': hintpassword,
      'id': id,
      'companies': companies,
      'updatedOn': updatedOn,
      'token': token,
      'usergroup': userGroup,
      'dashboardAccess': dashboardAccess,
      'dashboardCategory': dashboardCategory,
      'backDateEntry': backDateEntry,
    };
  }

  factory NUserModel.fromMap(Map<String, dynamic> map) {
    return NUserModel(
      sId: map['_id'] != null ? map['_id'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : '',
      hintpassword:
          map['password'] != null ? map['hintpassword'] as String : '',
      id: map['id'] != null ? map['id'] as String : null,
      companies: map['companies'] != null
          ? List<String>.from(map['companies'] as List<dynamic>)
          : null,
      updatedOn: map['updatedOn'] != null ? map['updatedOn'] as String : null,
      userGroup: map['usergroup'] != null ? map['usergroup'] as String : null,
      dashboardAccess: map['dashboardAccess'] != null
          ? map['dashboardAccess'] as String
          : null,
      dashboardCategory: map['dashboardCategory'] != null
          ? map['dashboardCategory'] as String
          : null,
      backDateEntry:
          map['backDateEntry'] != null ? map['backDateEntry'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NUserModel.fromJson(String source) =>
      NUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
