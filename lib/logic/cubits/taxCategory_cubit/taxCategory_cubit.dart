import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repository/tax_category_repository.dart';
import 'taxCategory_state.dart';

class TaxCategoryCubit extends Cubit<CubitTaxCategoryStates> {
  TaxCategoryCubit() : super(CubitTaxCategoryLoading());

  Future<void> getTaxCategory() async {
    emit(CubitTaxCategoryLoading());
    try {
      final taxCategory = await TaxRateService().fetchTaxRates();
      emit(CubitTaxCategoryLoaded(taxCategories: taxCategory));
    } catch (e) {
      emit(CubitTaxCategoryError(e.toString()));
    }
  }
}
