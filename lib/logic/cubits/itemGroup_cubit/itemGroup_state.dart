import 'package:billingsphere/data/models/itemGroup/item_group_model.dart';

abstract class CubitItemGroupStates {}

class CubitItemGroupLoading extends CubitItemGroupStates {}

class CubitItemGroupLoaded extends CubitItemGroupStates {
  List<ItemsGroup> itemGroups;
  CubitItemGroupLoaded({required this.itemGroups});
}

class CubitItemGroupError extends CubitItemGroupStates {
  String error;
  CubitItemGroupError(this.error);
}
