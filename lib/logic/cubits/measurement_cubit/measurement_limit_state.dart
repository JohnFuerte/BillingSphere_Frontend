import '../../../data/models/measurementLimit/measurement_limit_model.dart';

abstract class CubitMeasurementLimitStates {}

class CubitMeasurementLimitLoading extends CubitMeasurementLimitStates {}

class CubitMeasurementLimitLoaded extends CubitMeasurementLimitStates {
  List<MeasurementLimit> measurementLimits;
  CubitMeasurementLimitLoaded({required this.measurementLimits});
}

class CubitMeasurementLimitError extends CubitMeasurementLimitStates {
  String error;
  CubitMeasurementLimitError(this.error);
}