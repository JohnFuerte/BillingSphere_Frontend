import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class InwardChallan {
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
  final List<Entry> entries;
  final List<Sundry2> sundry;
  final String remark;
  InwardChallan({
    required this.id,
    required this.companyCode,
    required this.no,
    required this.date,
    required this.type,
    required this.party,
    required this.place,
    required this.dcNo,
    required this.date2,
    required this.totalamount,
    required this.entries,
    required this.sundry,
    required this.remark,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'entries': entries.map((x) => x.toMap()).toList(),
      'sundry': sundry.map((x) => x.toMap()).toList(),
      'remark': remark,
    };
  }

  factory InwardChallan.fromMap(Map<String, dynamic> map) {
    return InwardChallan(
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
      entries: (map['entries'] as List<dynamic>)
          .map((entryJson) => Entry.fromJson(entryJson))
          .toList(),
      sundry: (map['sundry'] as List<dynamic>)
          .map((sundryJson) => Sundry2.fromJson(sundryJson))
          .toList(),
      remark: map['remark'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InwardChallan.fromJson(String source) =>
      InwardChallan.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Entry {
  final String itemName;
  final int qty;
  final double rate;
  final String unit;
  final double netAmount;

  Entry({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.unit,
    required this.netAmount,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      itemName: json['itemName'],
      qty: json['qty'],
      rate: json['rate'],
      unit: json['unit'],
      netAmount: json['netAmount'],
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

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'qty': qty,
      'rate': rate,
      'unit': unit,
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
