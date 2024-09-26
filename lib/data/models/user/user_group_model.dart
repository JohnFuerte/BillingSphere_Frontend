// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserGroup {
  String? companyCode;
  String? id;
  String? userGroupName;
  String? ownerGroup;
  String? misReport;
  String? report;
  String? addMaster;
  String? editMaster;
  String? deleteMaster;
  String? purchase;
  String? sales;
  String? purchaseReturn;
  String? salesReturn;
  String? stock;
  String? shortage;
  String? jobcard;
  String? receiptNote;
  String? deliveryNote;
  String? purchaseOrder;
  String? salesOrder;
  String? salesQuotation;
  String? purchaseEnquiry;
  String? journal;
  String? conta;
  String? receipt2;
  String? payment;

  UserGroup({
    this.companyCode,
    this.id,
    this.userGroupName,
    this.ownerGroup,
    this.misReport,
    this.report,
    this.addMaster,
    this.editMaster,
    this.deleteMaster,
    this.purchase,
    this.sales,
    this.purchaseReturn,
    this.salesReturn,
    this.stock,
    this.shortage,
    this.jobcard,
    this.receiptNote,
    this.deliveryNote,
    this.purchaseOrder,
    this.salesOrder,
    this.salesQuotation,
    this.purchaseEnquiry,
    this.journal,
    this.conta,
    this.receipt2,
    this.payment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyCode': companyCode,
      'id': id,
      'userGroupName': userGroupName,
      'ownerGroup': ownerGroup,
      'misReport': misReport,
      'report': report,
      'addMaster': addMaster,
      'editMaster': editMaster,
      'deleteMaster': deleteMaster,
      'purchase': purchase,
      'sales': sales,
      'purchaseReturn': purchaseReturn,
      'salesReturn': salesReturn,
      'stock': stock,
      'shortage': shortage,
      'jobcard': jobcard,
      'receiptNote': receiptNote,
      'deliveryNote': deliveryNote,
      'purchaseOrder': purchaseOrder,
      'salesOrder': salesOrder,
      'salesQuotation': salesQuotation,
      'purchaseEnquiry': purchaseEnquiry,
      'journal': journal,
      'conta': conta,
      'receipt2': receipt2,
      'payment': payment,
    };
  }

  factory UserGroup.fromMap(Map<String, dynamic> map) {
    return UserGroup(
      companyCode: map['companyCode'] != null ? map['companyCode'] as String : null,
      id: map['_id'] != null ? map['_id'] as String : null,
      userGroupName:
          map['userGroupName'] != null ? map['userGroupName'] as String : null,
      ownerGroup:
          map['ownerGroup'] != null ? map['ownerGroup'] as String : null,
      misReport: map['misReport'] != null ? map['misReport'] as String : null,
      report: map['report'] != null ? map['report'] as String : null,
      addMaster: map['addMaster'] != null ? map['addMaster'] as String : null,
      editMaster:
          map['editMaster'] != null ? map['editMaster'] as String : null,
      deleteMaster:
          map['deleteMaster'] != null ? map['deleteMaster'] as String : null,
      purchase: map['purchase'] != null ? map['purchase'] as String : null,
      sales: map['sales'] != null ? map['sales'] as String : null,
      purchaseReturn: map['purchaseReturn'] != null
          ? map['purchaseReturn'] as String
          : null,
      salesReturn:
          map['salesReturn'] != null ? map['salesReturn'] as String : null,
      stock: map['stock'] != null ? map['stock'] as String : null,
      shortage: map['shortage'] != null ? map['shortage'] as String : null,
      jobcard: map['jobcard'] != null ? map['jobcard'] as String : null,
      receiptNote:
          map['receiptNote'] != null ? map['receiptNote'] as String : null,
      deliveryNote:
          map['deliveryNote'] != null ? map['deliveryNote'] as String : null,
      purchaseOrder:
          map['purchaseOrder'] != null ? map['purchaseOrder'] as String : null,
      salesOrder:
          map['salesOrder'] != null ? map['salesOrder'] as String : null,
      salesQuotation: map['salesQuotation'] != null
          ? map['salesQuotation'] as String
          : null,
      purchaseEnquiry: map['purchaseEnquiry'] != null
          ? map['purchaseEnquiry'] as String
          : null,
      journal: map['journal'] != null ? map['journal'] as String : null,
      conta: map['conta'] != null ? map['conta'] as String : null,
      receipt2: map['receipt2'] != null ? map['receipt2'] as String : null,
      payment: map['payment'] != null ? map['payment'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGroup.fromJson(String source) =>
      UserGroup.fromMap(json.decode(source) as Map<String, dynamic>);
}
