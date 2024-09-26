import 'package:billingsphere/data/models/brand/item_brand_model.dart';

abstract class CubitItemBrandStates {}

class CubitItemBrandLoading extends CubitItemBrandStates {}

class CubitItemBrandLoaded extends CubitItemBrandStates {
  List<ItemsBrand> itemBrands;
  CubitItemBrandLoaded({required this.itemBrands});
}

class CubitItemBrandError extends CubitItemBrandStates {
  String error;
  CubitItemBrandError(this.error);
}
