class PurchaseReturn {
  final String id;
  final String no;
  final String companyCode;
  final String type;
  final String date;
  final String place;
  final String billNumber;
  final String ledger;
  final String? remarks;
  final String totalAmount;
  final String? cashAmount;
  final List<Entry> entries;
  final List<Billwise> billwise;
  final List<Sundry> sundry;

  PurchaseReturn({
    required this.id,
    required this.no,
    required this.companyCode,
    required this.type,
    required this.date,
    required this.place,
    required this.billNumber,
    required this.ledger,
    this.remarks,
    required this.totalAmount,
    this.cashAmount,
    required this.entries,
    required this.billwise,
    required this.sundry,
  });

  factory PurchaseReturn.fromJson(Map<String, dynamic> json) {
    return PurchaseReturn(
      id: json['_id'],
      no: json['no'],
      companyCode: json['companyCode'],
      type: json['type'],
      date: json['date'],
      place: json['place'],
      billNumber: json['billNumber'],
      ledger: json['ledger'],
      remarks: json['remarks'],
      totalAmount: json['totalAmount'],
      cashAmount: json['cashAmount'],
      entries: (json['entries'] as List).map((e) => Entry.fromJson(e)).toList(),
      billwise:
          (json['billwise'] as List).map((b) => Billwise.fromJson(b)).toList(),
      sundry: (json['sundry'] as List).map((s) => Sundry.fromJson(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // '_id': id,
      'no': no,
      'companyCode': companyCode,
      'type': type,
      'date': date,
      'place': place,
      'billNumber': billNumber,
      'ledger': ledger,
      'remarks': remarks,
      'totalAmount': totalAmount,
      'cashAmount': cashAmount,
      'entries': entries.map((e) => e.toJson()).toList(),
      'billwise': billwise.map((b) => b.toJson()).toList(),
      'sundry': sundry.map((s) => s.toJson()).toList(),
    };
  }
}

class Entry {
  final String itemName;
  final int qty;
  final double rate;
  final String unit;
  final double amount;
  final String tax;
  final double sgst;
  final double cgst;
  final double discount;
  final double igst;
  final double netAmount;
  final double sellingPrice;

  Entry({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.unit,
    required this.amount,
    required this.tax,
    required this.sgst,
    required this.cgst,
    required this.discount,
    required this.igst,
    required this.netAmount,
    required this.sellingPrice,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      itemName: json['itemName'],
      qty: json['qty'],
      rate: json['rate'],
      unit: json['unit'],
      amount: json['amount'],
      tax: json['tax'],
      sgst: json['sgst'],
      cgst: json['cgst'],
      discount: json['discount'],
      igst: json['igst'],
      netAmount: json['netAmount'],
      sellingPrice: json['sellingPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'qty': qty,
      'rate': rate,
      'unit': unit,
      'amount': amount,
      'tax': tax,
      'sgst': sgst,
      'cgst': cgst,
      'discount': discount,
      'igst': igst,
      'netAmount': netAmount,
      'sellingPrice': sellingPrice,
    };
  }
}

class Billwise {
  final String date;
  final String purchase;
  final String? billNo;
  final double? amount;

  Billwise({
    required this.date,
    required this.purchase,
    this.billNo,
    this.amount,
  });

  factory Billwise.fromJson(Map<String, dynamic> json) {
    return Billwise(
      date: json['date'],
      purchase: json['purchase'],
      billNo: json['billNo'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'purchase': purchase,
      'billNo': billNo,
      'amount': amount,
    };
  }
}

class Sundry {
  final String sundryName;
  final double amount;

  Sundry({
    required this.sundryName,
    required this.amount,
  });

  factory Sundry.fromJson(Map<String, dynamic> json) {
    return Sundry(
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
