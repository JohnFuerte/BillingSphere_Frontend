import 'package:billingsphere/logic/cubits/measurement_cubit/measurement_limit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repository/measurement_limit_repository.dart';

class MeasurementLimitCubit extends Cubit<CubitMeasurementLimitStates> {
  MeasurementLimitCubit() : super(CubitMeasurementLimitLoading());

  Future<void> getLimit() async {
    emit(CubitMeasurementLimitLoading());
    try {
      final limits = await MeasurementLimitService().fetchMeasurementLimits();

      emit(CubitMeasurementLimitLoaded(measurementLimits: limits));
    } catch (e) {
      emit(CubitMeasurementLimitError(e.toString()));
    }
  }
}
