import 'package:billingsphere/data/models/item/item_model.dart';

abstract class CubitItemStates {}

class CubitItemLoading extends CubitItemStates {}

class CubitItemLoaded extends CubitItemStates {
  List<Item> items;
  CubitItemLoaded({required this.items});
}

class CubitItemError extends CubitItemStates {
  String error;
  CubitItemError(this.error);
}
