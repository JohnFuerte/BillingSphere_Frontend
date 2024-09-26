import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductStockModel {
  String id;
  String company;
  String product;
  int quantity;
  double price;
  double sellingPrice;
  String isActive;
  ProductStockModel({
    required this.id,
    required this.company,
    required this.product,
    required this.quantity,
    required this.price,
    required this.sellingPrice,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'company': company,
      'product': product,
      'quantity': quantity,
      'price': price,
      'sellingPrice': sellingPrice,
      'isActive': isActive,
    };
  }

  factory ProductStockModel.fromMap(Map<String, dynamic> map) {
    return ProductStockModel(
      id: map['_id'] as String,
      company: map['company'] as String,
      product: map['product'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      sellingPrice: map['selling_price'] as double,
      isActive: map['isActive'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductStockModel.fromJson(String source) =>
      ProductStockModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
