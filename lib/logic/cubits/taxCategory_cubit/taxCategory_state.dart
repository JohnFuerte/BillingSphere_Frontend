import '../../../data/models/taxCategory/tax_category_model.dart';

abstract class CubitTaxCategoryStates {}

class CubitTaxCategoryLoading extends CubitTaxCategoryStates {}

class CubitTaxCategoryLoaded extends CubitTaxCategoryStates {
  List<TaxRate> taxCategories;
  CubitTaxCategoryLoaded({required this.taxCategories});
}

class CubitTaxCategoryError extends CubitTaxCategoryStates {
  String error;
  CubitTaxCategoryError(this.error);
}