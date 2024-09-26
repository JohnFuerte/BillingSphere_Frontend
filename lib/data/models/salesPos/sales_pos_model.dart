// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SalesPos {
  final String id;
  final int no;
  final String date;
  final String companyCode;
  final String place;
  final String type;
  final String setDiscount;
  final String ac;
  final String noc;
  final List<POSEntry> entries;
  final String customer;
  final String billedTo;
  final String remarks;
  final double advance;
  final double addition;
  final double less;
  final double roundOff;
  final double totalAmount;
  final String? createdAt;
  final String? updatedAt;

  SalesPos({
    required this.id,
    required this.no,
    required this.date,
    required this.companyCode,
    required this.place,
    required this.type,
    required this.setDiscount,
    required this.ac,
    required this.noc,
    required this.advance,
    required this.addition,
    required this.less,
    required this.roundOff,
    required this.entries,
    required this.customer,
    required this.billedTo,
    required this.remarks,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'no': no,
      'date': date,
      'companyCode': companyCode,
      'place': place,
      'type': type,
      'setDiscount': setDiscount,
      'ac': ac,
      'noc': noc,
      'advance': advance,
      'addition': addition,
      'less': less,
      'roundOff': roundOff,
      'entries': entries.map((x) => x.toMap()).toList(),
      'customer': customer,
      'billedTo': billedTo,
      'remarks': remarks,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SalesPos.fromMap(Map<String, dynamic> map) {
    return SalesPos(
      id: map['_id'] as String,
      no: map['no'] as int,
      date: map['date'] as String,
      companyCode: map['companyCode'] as String,
      place: map['place'] as String,
      type: map['type'] as String,
      setDiscount: map['setDiscount'] as String,
      ac: map['ac'] as String,
      noc: map['noc'] as String,
      advance: map['advance'] as double,
      addition: map['addition'] as double,
      less: map['less'] as double,
      roundOff: map['roundOff'] as double,
      entries: (map['entries'] as List<dynamic>)
          .map((entryJson) => POSEntry.fromMap(entryJson))
          .toList(),
      customer: map['customer'] as String,
      billedTo: map['billedTo'] as String,
      remarks: map['remarks'] as String,
      totalAmount: map['totalAmount'] as double,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesPos.fromJson(String source) =>
      SalesPos.fromMap(json.decode(source) as Map<String, dynamic>);
}

class POSEntry {
  final String itemName;
  final int qty;
  final double rate;
  final String unit;
  final double netAmount;
  final double basic;
  final double dis;
  final double disc;
  final double tax;
  final double base;
  final double amount;
  final double mrp;

  POSEntry({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.unit,
    required this.netAmount,
    required this.basic,
    required this.dis,
    required this.disc,
    required this.tax,
    required this.base,
    required this.amount,
    required this.mrp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'qty': qty,
      'rate': rate,
      'unit': unit,
      'netAmount': netAmount,
      'basic': basic,
      'dis': dis,
      'disc': disc,
      'tax': tax,
      'base': base,
      'amount': amount,
      'mrp': mrp,
    };
  }

  factory POSEntry.fromMap(Map<String, dynamic> map) {
    return POSEntry(
      itemName: map['itemName'] as String,
      qty: map['qty'] as int,
      rate: map['rate'] as double,
      unit: map['unit'] as String,
      netAmount: map['netAmount'] as double,
      basic: map['basic'] as double,
      dis: map['dis'] as double,
      disc: map['disc'] as double,
      tax: map['tax'] as double,
      base: map['base'] as double,
      amount: map['amount'] as double,
      mrp: map['mrp'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory POSEntry.fromJson(String source) =>
      POSEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
