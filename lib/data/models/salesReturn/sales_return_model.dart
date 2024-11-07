class SalesReturn {
  final String? id;
  final String no;
  final String companyCode;
  final String type;
  final String date;
  final String date2;
  final String place;
  final String billNumber;
  final String ledger;
  final String? remarks;
  final String totalAmount;
  final String? cashAmount;
  final List<SalesEntry> entries;
  final List<Billwise> billwise;
  final List<Sundry> sundry;

  SalesReturn({
    this.id,
    required this.no,
    required this.companyCode,
    required this.type,
    required this.date,
    required this.date2,
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

  factory SalesReturn.fromJson(Map<String, dynamic> json) {
    return SalesReturn(
      id: json['_id'],
      no: json['no'],
      companyCode: json['companyCode'],
      type: json['type'],
      date: json['date'],
      date2: json['date2'],
      place: json['place'],
      billNumber: json['billNumber'],
      ledger: json['ledger'],
      remarks: json['remarks'],
      totalAmount: json['totalAmount'],
      cashAmount: json['cashAmount'],
      entries: (json['entries'] as List)
          .map((entry) => SalesEntry.fromJson(entry))
          .toList(),
      billwise:
          (json['billwise'] as List).map((b) => Billwise.fromJson(b)).toList(),
      sundry: (json['sundry'] as List).map((s) => Sundry.fromJson(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'companyCode': companyCode,
      'type': type,
      'date': date,
      'date2': date2,
      'place': place,
      'billNumber': billNumber,
      'ledger': ledger,
      'remarks': remarks,
      'totalAmount': totalAmount,
      'cashAmount': cashAmount,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'billwise': billwise.map((b) => b.toJson()).toList(),
      'sundry': sundry.map((s) => s.toJson()).toList(),
    };
  }
}

class SalesEntry {
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

  SalesEntry({
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

  factory SalesEntry.fromJson(Map<String, dynamic> json) {
    return SalesEntry(
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
  final String sales;
  final String? billNo;
  final double? amount;

  Billwise({
    required this.date,
    required this.sales,
    this.billNo,
    this.amount,
  });

  factory Billwise.fromJson(Map<String, dynamic> json) {
    return Billwise(
      date: json['date'],
      sales: json['sales'],
      billNo: json['billNo'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sales': sales,
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
