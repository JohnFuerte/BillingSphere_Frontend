import 'dart:convert';


class ItemsBrand {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedOn;

  ItemsBrand({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
    };
  }

  factory ItemsBrand.fromMap(Map<String, dynamic> map) {
    return ItemsBrand(
      id: map['_id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedOn: DateTime.parse(map['updatedOn'].toString()),
    );
  }
  String toJson() => json.encode(toMap());

  factory ItemsBrand.fromJson(String source) =>
      ItemsBrand.fromMap(json.decode(source) as Map<String, dynamic>);
}
