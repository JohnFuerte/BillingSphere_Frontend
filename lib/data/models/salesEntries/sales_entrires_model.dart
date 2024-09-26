// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SalesEntry {
  final String id;
  final String companyCode;
  final int no;
  final String date;
  final String type;
  final String party;
  final String place;
  final String dcNo;
  final String date2;
  final String totalamount;
  String dueAmount;
  String cashAmount;
  final double roundoffDiff;
  final List<Entry> entries;
  final List<Sundry2> sundry;
  final List<Dispatch> dispatch;
  final List<Multimode> multimode;
  final List<MoreDetails> moredetails;
  final String remark;

  SalesEntry({
    required this.id,
    required this.companyCode,
    required this.dispatch,
    required this.no,
    required this.date,
    required this.type,
    required this.party,
    required this.place,
    required this.dcNo,
    required this.date2,
    required this.totalamount,
    required this.dueAmount,
    required this.cashAmount,
    required this.roundoffDiff,
    required this.entries,
    required this.sundry,
    required this.multimode,
    required this.moredetails,
    required this.remark,
  });

  factory SalesEntry.fromJson(Map<String, dynamic> json) {
    return SalesEntry(
      companyCode: json['companyCode'],
      id: json['_id'],
      no: json['no'],
      date: json['date'],
      type: json['type'],
      party: json['party'],
      place: json['place'],
      dcNo: json['dcNo'],
      date2: json['date'],
      totalamount: json['totalamount'],
      dueAmount: json['dueAmount'],
      cashAmount: json['cashAmount'],
      roundoffDiff: json['roundoffDiff'],
      entries: (json['entries'] as List<dynamic>)
          .map((entryJson) => Entry.fromJson(entryJson))
          .toList(),
      sundry: (json['sundry'] as List<dynamic>)
          .map((sundryJson) => Sundry2.fromJson(sundryJson))
          .toList(),
      dispatch: (json['dispatch'] as List<dynamic>)
          .map((dispatchJson) => Dispatch.fromMap(dispatchJson))
          .toList(),
      multimode: (json['multimode'] as List<dynamic>)
          .map((multimodeJson) => Multimode.fromMap(multimodeJson))
          .toList(),
      moredetails: (json['moredetails'] as List<dynamic>)
          .map((moredetailsJson) => MoreDetails.fromMap(moredetailsJson))
          .toList(),
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyCode': companyCode,
      'no': no,
      'date': date,
      'type': type,
      'party': party,
      'place': place,
      'dcNo': dcNo,
      'date2': date2,
      'totalamount': totalamount,
      'dueAmount': dueAmount,
      'cashAmount': cashAmount,
      'roundoffDiff': roundoffDiff,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'sundry': sundry.map((sundry) => sundry.toJson()).toList(),
      'dispatch': dispatch.map((dispatch) => dispatch.toMap()).toList(),
      'multimode': multimode.map((multimode) => multimode.toMap()).toList(),
      'moredetails': moredetails.map((multimode) => multimode.toMap()).toList(),
      'remark': remark,
    };
  }

  factory SalesEntry.fromMap(Map<String, dynamic> map) {
    return SalesEntry(
      dispatch: (map['dispatch'] as List<dynamic>)
          .map((dispatchJson) => Dispatch.fromMap(dispatchJson))
          .toList(),
      multimode: (map['multimode'] as List<dynamic>)
          .map((multimodeJson) => Multimode.fromMap(multimodeJson))
          .toList(),
      moredetails: (map['moredetails'] as List<dynamic>)
          .map((moredetailsJson) => MoreDetails.fromMap(moredetailsJson))
          .toList(),
      id: map['_id'] as String,
      companyCode: map['companyCode'] as String,
      no: map['no'] as int,
      date: map['date'] as String,
      type: map['type'] as String,
      party: map['party'] as String,
      place: map['place'] as String,
      dcNo: map['dcNo'] as String,
      date2: map['date2'] as String,
      totalamount: map['totalamount'] as String,
      dueAmount: map['dueAmount'] as String,
      cashAmount: map['cashAmount'] as String,
      roundoffDiff: map['roundoffDiff'] as double,
      entries: (map['entries'] as List<dynamic>)
          .map((entryJson) => Entry.fromJson(entryJson))
          .toList(),
      sundry: (map['sundry'] as List<dynamic>)
          .map((sundryJson) => Sundry2.fromJson(sundryJson))
          .toList(),
      remark: map['remark'] as String,
    );
  }
}

class Entry {
  final String itemName;
  final int qty;
  final String? additionalInfo;
  final double rate;
  final double baseRate;
  final String unit;
  final double amount;
  final String tax;
  final double discount;
  final double originaldiscount;
  final double sgst;
  final double cgst;
  final double igst;
  final double netAmount;

  Entry({
    required this.itemName,
    required this.qty,
    this.additionalInfo,
    required this.rate,
    required this.baseRate,
    required this.unit,
    required this.amount,
    required this.tax,
    required this.discount,
    required this.originaldiscount,
    required this.sgst,
    required this.cgst,
    required this.igst,
    required this.netAmount,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      itemName: json['itemName'],
      additionalInfo: json['additionalInfo'],
      qty: json['qty'],
      rate: json['rate'],
      baseRate: json['baseRate'],
      unit: json['unit'],
      amount: json['amount'],
      tax: json['tax'],
      discount: json['discount'],
      originaldiscount: json['originaldiscount'],
      sgst: json['sgst'],
      cgst: json['cgst'],
      igst: json['igst'],
      netAmount: json['netAmount'],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'additionalInfo': additionalInfo,
      'qty': qty,
      'rate': rate,
      'baseRate': baseRate,
      'unit': unit,
      'amount': amount,
      'tax': tax,
      'discount': discount,
      'originaldiscount': originaldiscount,
      'sgst': sgst,
      'cgst': cgst,
      'igst': igst,
      'netAmount': netAmount,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'additionalInfo': additionalInfo,
      'qty': qty,
      'rate': rate,
      'baseRate': baseRate,
      'unit': unit,
      'amount': amount,
      'tax': tax,
      'discount': discount,
      'originaldiscount': originaldiscount,
      'sgst': sgst,
      'cgst': cgst,
      'igst': igst,
      'netAmount': netAmount,
    };
  }
}

class Sundry2 {
  final String sundryName;
  final double amount;

  Sundry2({
    required this.sundryName,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sundryName': sundryName,
      'amount': amount,
    };
  }

  factory Sundry2.fromJson(Map<String, dynamic> json) {
    return Sundry2(
      sundryName: json['sundryName'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sundryName': sundryName,
      'amount': amount,
    };
  }
}

class Dispatch {
  final String transAgency;
  final String docketNo;
  final String vehicleNo;
  final String fromStation;
  final String fromDistrict;
  final String transMode;
  final String parcel;
  final String freight;
  final String kms;
  final String toState;
  final String ewayBill;
  final String billingAddress;
  final String shippedTo;
  final String shippingAddress;
  final String phoneNo;
  final String gstNo;
  final String remarks;
  final String licenceNo;
  final String issueState;
  final String name;
  final String address;

  Dispatch({
    required this.transAgency,
    required this.docketNo,
    required this.vehicleNo,
    required this.fromStation,
    required this.fromDistrict,
    required this.transMode,
    required this.parcel,
    required this.freight,
    required this.kms,
    required this.toState,
    required this.ewayBill,
    required this.billingAddress,
    required this.shippedTo,
    required this.shippingAddress,
    required this.phoneNo,
    required this.gstNo,
    required this.remarks,
    required this.licenceNo,
    required this.issueState,
    required this.name,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transAgency': transAgency,
      'docketNo': docketNo,
      'vehicleNo': vehicleNo,
      'fromStation': fromStation,
      'fromDistrict': fromDistrict,
      'transMode': transMode,
      'parcel': parcel,
      'freight': freight,
      'kms': kms,
      'toState': toState,
      'ewayBill': ewayBill,
      'billingAddress': billingAddress,
      'shippedTo': shippedTo,
      'shippingAddress': shippingAddress,
      'phoneNo': phoneNo,
      'gstNo': gstNo,
      'remarks': remarks,
      'licenceNo': licenceNo,
      'issueState': issueState,
      'name': name,
      'address': address,
    };
  }

  factory Dispatch.fromMap(Map<String, dynamic> map) {
    return Dispatch(
      transAgency: map['transAgency'] as String,
      docketNo: map['docketNo'] as String,
      vehicleNo: map['vehicleNo'] as String,
      fromStation: map['fromStation'] as String,
      fromDistrict: map['fromDistrict'] as String,
      transMode: map['transMode'] as String,
      parcel: map['parcel'] as String,
      freight: map['freight'] as String,
      kms: map['kms'] as String,
      toState: map['toState'] as String,
      ewayBill: map['ewayBill'] as String,
      billingAddress: map['billingAddress'] as String,
      shippedTo: map['shippedTo'] as String,
      shippingAddress: map['shippingAddress'] as String,
      phoneNo: map['phoneNo'] as String,
      gstNo: map['gstNo'] as String,
      remarks: map['remarks'] as String,
      licenceNo: map['licenceNo'] as String,
      issueState: map['issueState'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dispatch.fromJson(String source) =>
      Dispatch.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Multimode {
  final double? cash;
  final double? debit;
  final double? adjustedamount;
  final double? pending;
  final double? finalamount;

  Multimode({
    this.cash,
    this.debit,
    this.adjustedamount,
    this.pending,
    this.finalamount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cash': cash,
      'debit': debit,
      'adjustedamount': adjustedamount,
      'pending': pending,
      'finalamount': finalamount,
    };
  }

  factory Multimode.fromMap(Map<String, dynamic> map) {
    return Multimode(
      cash: map['cash'] != null ? map['cash'] as double : null,
      debit: map['debit'] != null ? map['debit'] as double : null,
      adjustedamount: map['adjustedamount'] != null
          ? map['adjustedamount'] as double
          : null,
      pending: map['pending'] != null ? map['pending'] as double : null,
      finalamount:
          map['finalamount'] != null ? map['finalamount'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Multimode.fromJson(String source) =>
      Multimode.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MoreDetails {
  final String? advpayment;
  final String? advpaymentdate;
  final String? installment;
  final String? toteldebitamount;

  MoreDetails({
    this.advpayment,
    this.advpaymentdate,
    this.installment,
    this.toteldebitamount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'advpayment': advpayment,
      'advpaymentdate': advpaymentdate,
      'installment': installment,
      'toteldebitamount': toteldebitamount,
    };
  }

  factory MoreDetails.fromMap(Map<String, dynamic> map) {
    return MoreDetails(
      advpayment:
          map['advpayment'] != null ? map['advpayment'] as String : null,
      advpaymentdate: map['advpaymentdate'] != null
          ? map['advpaymentdate'] as String
          : null,
      installment:
          map['installment'] != null ? map['installment'] as String : null,
      toteldebitamount: map['toteldebitamount'] != null
          ? map['toteldebitamount'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoreDetails.fromJson(String source) =>
      MoreDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}
