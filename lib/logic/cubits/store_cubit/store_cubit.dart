import 'package:billingsphere/logic/cubits/store_cubit/store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repository/store_location_repository.dart';

class CubitStore extends Cubit<CubitStoreStates> {
  CubitStore() : super(CubicStoreLoading());

  Future<void> getStores() async {
    emit(CubicStoreLoading());
    try {
      final stores = await StoreLocationService().fetchStoreLocations();

      emit(CubicStoreLoaded(stores: stores));
    } catch (e) {
      emit(CubitStoreError(e.toString()));
    }
  }
}
