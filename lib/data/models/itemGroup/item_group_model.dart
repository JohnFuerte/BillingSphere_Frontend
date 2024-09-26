import 'dart:convert';

import 'package:billingsphere/data/models/item/item_model.dart';

class ItemsGroup {
  String id;
  String desc;
  String name;
  DateTime createdAt;
  DateTime updatedOn;
  List<ImageData>? images;

  ItemsGroup({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedOn,
    required this.desc,
    this.images,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'desc': desc,
      'images': images?.map((image) => image.toJson()).toList(),
    };
  }

  factory ItemsGroup.fromMap(Map<String, dynamic> map) {
    return ItemsGroup(
      id: map['_id'] as String,
      name: map['name'] as String,
      desc: map['desc'] as String,
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedOn: DateTime.parse(map['updatedOn'].toString()),
      images: (map['images'] as List<dynamic>?)
          ?.map<ImageData>((dynamic json) =>
              ImageData.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }
  String toJson() => json.encode(toMap());

  factory ItemsGroup.fromJson(String source) =>
      ItemsGroup.fromMap(json.decode(source) as Map<String, dynamic>);
}
