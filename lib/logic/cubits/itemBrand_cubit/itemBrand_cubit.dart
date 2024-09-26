import 'package:billingsphere/data/repository/item_brand_repository.dart';
import 'package:billingsphere/logic/cubits/itemBrand_cubit/itemBrand_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemBrandCubit extends Cubit<CubitItemBrandStates> {
  ItemBrandCubit() : super(CubitItemBrandLoading());

  Future<void> getItemBrand() async {
    emit(CubitItemBrandLoading());
    try {
      final itemBrand = await ItemsBrandsService().fetchItemBrands();
      emit(CubitItemBrandLoaded(itemBrands: itemBrand));
    } catch (e) {
      emit(CubitItemBrandError(e.toString()));
    }
  }
}
