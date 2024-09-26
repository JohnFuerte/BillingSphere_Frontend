import '../../../data/models/storeLocation/store_location_model.dart';

abstract class CubitStoreStates {}

class CubicStoreLoading extends CubitStoreStates {}

class CubicStoreLoaded extends CubitStoreStates {
  List<StoreLocation> stores;
  CubicStoreLoaded({required this.stores});
}


class CubitStoreError extends CubitStoreStates {
  String error;
  CubitStoreError(this.error);
}