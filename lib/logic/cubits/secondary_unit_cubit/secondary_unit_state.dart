import '../../../data/models/secondaryUnit/secondary_unit_model.dart';

abstract class CubitSecondaryUnitStates {}

class CubitSecondaryUnitLoading extends CubitSecondaryUnitStates {}

class CubitSecondaryUnitLoaded extends CubitSecondaryUnitStates {
  List<SecondaryUnit> secondaryUnits;
  CubitSecondaryUnitLoaded({required this.secondaryUnits});
}

class CubitSecondaryUnitError extends CubitSecondaryUnitStates {
  String error;
  CubitSecondaryUnitError(this.error);
}