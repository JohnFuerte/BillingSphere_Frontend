// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../item/item_model.dart';

class ItemsBrand {
  String id;
  String name;
  List<ImageData>? images;
  DateTime createdAt;
  DateTime updatedOn;

  ItemsBrand({
    required this.id,
    required this.name,
    this.images,
    required this.createdAt,
    required this.updatedOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'images': images,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
    };
  }

  factory ItemsBrand.fromMap(Map<String, dynamic> map) {
    return ItemsBrand(
      id: map['_id'],
      name: map['name'],
      images: (map['images'] as List<dynamic>?)
          ?.map<ImageData>((dynamic json) =>
              ImageData.fromJson(json as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedOn: DateTime.parse(map['updatedOn'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsBrand.fromJson(String source) =>
      ItemsBrand.fromMap(json.decode(source) as Map<String, dynamic>);
}
