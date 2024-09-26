import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/secondary_unit_repository.dart';
import 'secondary_unit_state.dart';

class SecondaryUnitCubit extends Cubit<CubitSecondaryUnitStates> {
  SecondaryUnitCubit() : super(CubitSecondaryUnitLoading());

  Future<void> getLimit() async {
    emit(CubitSecondaryUnitLoading());
    try {
      final units = await SecondaryUnitService().fetchSecondaryUnits();

      emit(CubitSecondaryUnitLoaded(secondaryUnits: units));
    } catch (e) {
      emit(CubitSecondaryUnitError(e.toString()));
    }
  }
}
