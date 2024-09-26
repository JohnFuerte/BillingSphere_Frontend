// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Purchase {
  final String id;
  final String companyCode;
  final String totalamount;
  final String no;
  final String date;
  final String date2;
  final String type;
  final String ledger;
  final String place;
  final String billNumber;
  final String remarks;
  final String? cashAmount;
  String? dueAmount;
  final double roundoffDiff;
  final List<PurchaseEntry> entries;
  final List<SundryEntry?> sundry;

  Purchase({
    required this.id,
    required this.companyCode,
    required this.totalamount,
    required this.no,
    required this.date,
    required this.cashAmount,
    required this.dueAmount,
    required this.roundoffDiff,
    required this.date2,
    required this.type,
    required this.ledger,
    required this.place,
    required this.billNumber,
    required this.remarks,
    required this.entries,
    required this.sundry,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'companyCode': companyCode,
      'totalamount': totalamount,
      'cashAmount': cashAmount,
      'dueAmount': dueAmount,
      'roundoffDiff': roundoffDiff,
      'no': no,
      'date': date,
      'date2': date2,
      'type': type,
      'ledger': ledger,
      'place': place,
      'billNumber': billNumber,
      'remarks': remarks,
      'entries': entries.map((x) => x.toMap()).toList(),
      'sundry': sundry.map((x) => x!.toMap()).toList(),
      // 'sundry': sundry.map((x) => x.toMap()).toList(),
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      companyCode: map['companyCode'] as String,
      totalamount: map['totalamount'] as String,
      id: map['_id'] as String,
      no: map['no'] as String,
      date: map['date'] as String,
      date2: map['date2'] as String,
      type: map['type'] as String,
      cashAmount: map['cashAmount'] as String,
      dueAmount: map['dueAmount'] as String,
      roundoffDiff: map['roundoffDiff'] as double,
      ledger: map['ledger'] as String,
      place: map['place'] as String,
      billNumber: map['billNumber'] as String,
      remarks: map['remarks'] as String,
      entries: List<PurchaseEntry>.from(
        (map['entries'] as List<dynamic>).map<PurchaseEntry>(
          (x) => PurchaseEntry.fromMap(x as Map<String, dynamic>),
        ),
      ),
      sundry: List<SundryEntry?>.from(
        (map['sundry'] as List<dynamic>).map<SundryEntry>(
          (x) => SundryEntry.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchase.fromJson(String source) =>
      Purchase.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PurchaseEntry {
  final String itemName;
  final int qty;
  final double rate;
  final String unit;
  final double amount;
  final String tax;
  final double sgst;
  final double discount;
  final double cgst;
  final double igst;
  final double netAmount;
  final double sellingPrice;

  PurchaseEntry({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.unit,
    required this.amount,
    required this.tax,
    required this.sgst,
    required this.discount,
    required this.cgst,
    required this.igst,
    required this.netAmount,
    required this.sellingPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'qty': qty,
      'rate': rate,
      'unit': unit,
      'amount': amount,
      'tax': tax,
      'discount': discount,
      'sgst': sgst,
      'cgst': cgst,
      'igst': igst,
      'netAmount': netAmount,
      'sellingPrice': sellingPrice,
    };
  }

  factory PurchaseEntry.fromMap(Map<String, dynamic> map) {
    return PurchaseEntry(
      itemName: map['itemName'] as String,
      qty: map['qty'] as int,
      rate: map['rate'] as double,
      unit: map['unit'] as String,
      amount: map['amount'] as double,
      tax: map['tax'] as String,
      discount: map['discount'] as double,
      sgst: map['sgst'] as double,
      cgst: map['cgst'] as double,
      igst: map['igst'] as double,
      netAmount: map['netAmount'] as double,
      sellingPrice: map['sellingPrice'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseEntry.fromJson(String source) =>
      PurchaseEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SundryEntry {
  final String? sundryName;
  final double? amount;

  SundryEntry({
    required this.sundryName,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sundryName': sundryName,
      'amount': amount,
    };
  }

  factory SundryEntry.fromMap(Map<String, dynamic> map) {
    return SundryEntry(
      sundryName: map['sundryName'] as String,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SundryEntry.fromJson(String source) =>
      SundryEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
