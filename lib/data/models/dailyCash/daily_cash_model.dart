// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DailyCashEntry {
  final String id;
  final String date;
  final String description;
  final String cashier;
  final List<TwoThousand>? twoThousand;
  final List<FiveHundred>? fiveHundred;
  final List<TwoHundred>? twoHundred;
  final List<OneHundred>? oneHundred;
  final List<Fifty>? fifty;
  final List<Twenty>? twenty;
  final List<Ten>? ten;
  final List<Coins>? coins;
  final double actualcash;
  final double? systemcash;
  final double excesscash;

  DailyCashEntry({
    required this.id,
    required this.date,
    required this.description,
    required this.cashier,
    this.twoThousand,
    this.fiveHundred,
    this.twoHundred,
    this.oneHundred,
    this.fifty,
    this.twenty,
    this.ten,
    this.coins,
    required this.actualcash,
    this.systemcash,
    required this.excesscash,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'description': description,
      'cashier': cashier,
      'twoThousand': twoThousand?.map((x) => x.toMap()).toList(),
      'fiveHundred': fiveHundred?.map((x) => x.toMap()).toList(),
      'twoHundred': twoHundred?.map((x) => x.toMap()).toList(),
      'oneHundred': oneHundred?.map((x) => x.toMap()).toList(),
      'fifty': fifty?.map((x) => x.toMap()).toList(),
      'twenty': twenty?.map((x) => x.toMap()).toList(),
      'ten': ten?.map((x) => x.toMap()).toList(),
      'coins': coins?.map((x) => x.toMap()).toList(),
      'actualcash': actualcash,
      'systemcash': systemcash,
      'excesscash': excesscash,
    };
  }

  factory DailyCashEntry.fromMap(Map<String, dynamic> map) {
    return DailyCashEntry(
      id: map['_id'] as String,
      date: map['date'] as String,
      description: map['description'] as String,
      cashier: map['cashier'] as String,
      twoThousand: (map['twoThousand'] != null)
          ? List<TwoThousand>.from(
              (map['twoThousand'] as List<dynamic>).map<TwoThousand>(
                (x) => TwoThousand.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      fiveHundred: (map['fiveHundred'] != null)
          ? List<FiveHundred>.from(
              (map['fiveHundred'] as List<dynamic>).map<FiveHundred>(
                (x) => FiveHundred.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      twoHundred: (map['twoHundred'] != null)
          ? List<TwoHundred>.from(
              (map['twoHundred'] as List<dynamic>).map<TwoHundred>(
                (x) => TwoHundred.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      oneHundred: (map['oneHundred'] != null)
          ? List<OneHundred>.from(
              (map['oneHundred'] as List<dynamic>).map<OneHundred>(
                (x) => OneHundred.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      fifty: (map['fifty'] != null)
          ? List<Fifty>.from(
              (map['fifty'] as List<dynamic>).map<Fifty>(
                (x) => Fifty.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      twenty: (map['twenty'] != null)
          ? List<Twenty>.from(
              (map['twenty'] as List<dynamic>).map<Twenty>(
                (x) => Twenty.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      ten: (map['ten'] != null)
          ? List<Ten>.from(
              (map['ten'] as List<dynamic>).map<Ten>(
                (x) => Ten.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      coins: (map['coins'] != null)
          ? List<Coins>.from(
              (map['coins'] as List<dynamic>).map<Coins>(
                (x) => Coins.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      actualcash: map['actualcash'] as double,
      systemcash: map['systemcash'] as double,
      excesscash: map['excesscash'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyCashEntry.fromJson(String source) =>
      DailyCashEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}

class TwoThousand {
  final double? qty;
  final double? total;

  TwoThousand({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory TwoThousand.fromMap(Map<String, dynamic> map) {
    return TwoThousand(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TwoThousand.fromJson(String source) =>
      TwoThousand.fromMap(json.decode(source) as Map<String, dynamic>);
}

class FiveHundred {
  final double? qty;
  final double? total;

  FiveHundred({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory FiveHundred.fromMap(Map<String, dynamic> map) {
    return FiveHundred(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory FiveHundred.fromJson(String source) =>
      FiveHundred.fromMap(json.decode(source) as Map<String, dynamic>);
}

class TwoHundred {
  final double? qty;
  final double? total;

  TwoHundred({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory TwoHundred.fromMap(Map<String, dynamic> map) {
    return TwoHundred(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TwoHundred.fromJson(String source) =>
      TwoHundred.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OneHundred {
  final double? qty;
  final double? total;

  OneHundred({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory OneHundred.fromMap(Map<String, dynamic> map) {
    return OneHundred(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OneHundred.fromJson(String source) =>
      OneHundred.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Fifty {
  final double? qty;
  final double? total;

  Fifty({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory Fifty.fromMap(Map<String, dynamic> map) {
    return Fifty(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Fifty.fromJson(String source) =>
      Fifty.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Twenty {
  final double? qty;
  final double? total;

  Twenty({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory Twenty.fromMap(Map<String, dynamic> map) {
    return Twenty(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Twenty.fromJson(String source) =>
      Twenty.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Ten {
  final double? qty;
  final double? total;

  Ten({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory Ten.fromMap(Map<String, dynamic> map) {
    return Ten(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ten.fromJson(String source) =>
      Ten.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Coins {
  final double? qty;
  final double? total;

  Coins({this.qty, this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'total': total,
    };
  }

  factory Coins.fromMap(Map<String, dynamic> map) {
    return Coins(
      qty: map['qty'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coins.fromJson(String source) =>
      Coins.fromMap(json.decode(source) as Map<String, dynamic>);
}
