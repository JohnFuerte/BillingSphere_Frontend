// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeliveryChallan {
  final String id;
  final String companyCode;
  final int no;
  final String date;
  final String type;
  final String party;
  final String place;
  final String ledger;
  final String dcNo;
  final String date2;
  final String totalamount;
  final List<DEntry> entries;
  final List<DSundry2> sundry;
  final String remark;

  DeliveryChallan({
    required this.id,
    required this.companyCode,
    required this.no,
    required this.date,
    required this.type,
    required this.party,
    required this.place,
    required this.ledger,
    required this.dcNo,
    required this.date2,
    required this.totalamount,
    required this.entries,
    required this.sundry,
    required this.remark,
  });

  factory DeliveryChallan.fromMap(Map<String, dynamic> map) {
    return DeliveryChallan(
      id: map['_id'] as String,
      companyCode: map['companyCode'] as String,
      no: map['no'] as int,
      date: map['date'] as String,
      type: map['type'] as String,
      party: map['party'] as String,
      place: map['place'] as String,
      ledger: map['ledger'] as String,
      dcNo: map['dcNo'] as String,
      date2: map['date2'] as String,
      totalamount: map['totalamount'] as String,
      entries: (map['entries'] as List<dynamic>)
          .map((entryJson) => DEntry.fromMap(entryJson))
          .toList(),
      sundry: (map['sundry'] as List<dynamic>)
          .map((sundryJson) => DSundry2.fromMap(sundryJson))
          .toList(),
      remark: map['remark'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'companyCode': companyCode,
      'no': no,
      'date': date,
      'type': type,
      'party': party,
      'place': place,
      'ledger': ledger,
      'dcNo': dcNo,
      'date2': date2,
      'totalamount': totalamount,
      'entries': entries.map((entry) => entry.toMap()).toList(),
      'sundry': sundry.map((sundry) => sundry.toMap()).toList(),
      'remark': remark,
    };
  }

  String toJson() => json.encode(toMap());

  factory DeliveryChallan.fromJson(String source) =>
      DeliveryChallan.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DEntry {
  final String itemName;
  final int qty;
  final double rate;
  final String unit;
  final double netAmount;

  DEntry({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.unit,
    required this.netAmount,
  });

  factory DEntry.fromMap(Map<String, dynamic> map) {
    return DEntry(
      itemName: map['itemName'] as String,
      qty: map['qty'] as int,
      rate: map['rate'] as double,
      unit: map['unit'] as String,
      netAmount: map['netAmount'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'qty': qty,
      'rate': rate,
      'unit': unit,
      'netAmount': netAmount,
    };
  }
}

class DSundry2 {
  final String sundryName;
  final double amount;

  DSundry2({
    required this.sundryName,
    required this.amount,
  });

  factory DSundry2.fromMap(Map<String, dynamic> map) {
    return DSundry2(
      sundryName: map['sundryName'] as String,
      amount: map['amount'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sundryName': sundryName,
      'amount': amount,
    };
  }
}
