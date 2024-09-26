// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

class Item {
  String id;
  String? companyCode;
  String itemGroup;
  String itemBrand;
  String itemName;
  String printName;
  String codeNo;
  String barcode;
  String taxCategory;
  String hsnCode;
  String storeLocation;
  String measurementUnit;
  String secondaryUnit;
  int minimumStock;
  int maximumStock;
  int monthlySalesQty;
  String date;
  double dealer;
  double subDealer;
  double retail;
  double mrp;
  String openingStock;
  String status;
  List<ImageData>? images;
  List<OpeningBalance> openingBalance;
  double openingBalanceQty;
  double openingBalanceAmt;

  final double? price;

  Item({
    required this.id,
    required this.itemGroup,
    required this.itemBrand,
    required this.itemName,
    required this.printName,
    required this.codeNo,
    required this.barcode,
    required this.taxCategory,
    required this.hsnCode,
    required this.storeLocation,
    required this.measurementUnit,
    required this.secondaryUnit,
    required this.minimumStock,
    required this.maximumStock,
    required this.monthlySalesQty,
    required this.date,
    required this.dealer,
    required this.subDealer,
    required this.retail,
    required this.mrp,
    required this.openingStock,
    required this.status,
    this.images,
    required this.openingBalance,
    required this.openingBalanceQty,
    required this.openingBalanceAmt,
    this.companyCode,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'itemGroup': itemGroup,
      'companyCode': companyCode ?? '',
      'itemBrand': itemBrand,
      'itemName': itemName,
      'printName': printName,
      'codeNo': codeNo,
      'barcode': barcode,
      'taxCategory': taxCategory,
      'hsnCode': hsnCode,
      'storeLocation': storeLocation,
      'measurementUnit': measurementUnit,
      'secondaryUnit': secondaryUnit,
      'minimumStock': minimumStock,
      'maximumStock': maximumStock,
      'monthlySalesQty': monthlySalesQty,
      'dealer': dealer,
      'subDealer': subDealer,
      'retail': retail,
      'mrp': mrp,
      'openingStock': openingStock,
      'status': status,
      'images': images?.map((image) => image.toJson()).toList(),
      'openingBalance': openingBalance
          .map((openingBalance) => openingBalance.toMap())
          .toList(),
      'openingBalanceQty': openingBalanceQty,
      'openingBalanceAmt': openingBalanceAmt,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['_id'] as String,
      itemGroup: map['itemGroup'] as String,
      itemBrand: map['itemBrand'] as String,
      companyCode: map['companyCode'] as String?,
      itemName: map['itemName'] as String,
      printName: map['printName'] as String,
      barcode: map['barcode'] as String,
      codeNo: map['codeNo'] as String,
      taxCategory: map['taxCategory'] as String,
      price: map['price'] as double,
      hsnCode: map['hsnCode'] as String,
      storeLocation: map['storeLocation'] as String,
      measurementUnit: map['measurementUnit'] as String,
      secondaryUnit: map['secondaryUnit'] as String,
      minimumStock: map['minimumStock'] as int,
      maximumStock: map['maximumStock'] as int,
      monthlySalesQty: map['monthlySalesQty'] as int,
      date: map['date'] as String,
      dealer: map['dealer'] as double,
      subDealer: map['subDealer'] as double,
      retail: map['retail'] as double,
      mrp: map['mrp'] as double,
      openingStock: map['openingStock'] as String,
      status: map['status'] as String,
      images: (map['images'] as List<dynamic>?)
          ?.map<ImageData>((dynamic json) =>
              ImageData.fromJson(json as Map<String, dynamic>))
          .toList(),
      openingBalance: (map['openingBalance'] as List<dynamic>?)
              ?.map((multimodeJson) => OpeningBalance.fromMap(multimodeJson))
              .toList() ??
          [],
      openingBalanceQty: map['openingBalanceQty'] as double,
      openingBalanceAmt: map['openingBalanceAmt'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ImageData {
  final Uint8List data;
  final String contentType;
  final String filename;

  ImageData({
    required this.data,
    required this.contentType,
    required this.filename,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      data: Uint8List.fromList(List<int>.from(json['data']['data'])),
      contentType: json['contentType'],
      filename: json['filename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': base64.encode(data),
      'contentType': contentType,
      'filename': filename,
    };
  }
}

class OpeningBalance {
  final int? qty;
  final String? unit;
  final double? rate;
  final double? total;

  OpeningBalance({
    this.qty,
    this.unit,
    this.rate,
    this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'unit': unit,
      'rate': rate,
      'total': total,
    };
  }

  factory OpeningBalance.fromMap(Map<String, dynamic> map) {
    return OpeningBalance(
      qty: map['qty'] != null ? map['qty'] as int : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      rate: map['rate'] != null ? map['rate'] as double : null,
      total: map['total'] != null ? map['total'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OpeningBalance.fromJson(String source) =>
      OpeningBalance.fromMap(json.decode(source) as Map<String, dynamic>);
}
