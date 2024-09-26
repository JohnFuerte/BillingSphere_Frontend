import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:billingsphere/data/repository/hsn_repository.dart';
import 'package:billingsphere/logic/cubits/hsn_cubit/hsn_state.dart';

class HSNCodeCubit extends Cubit<CubitHsnStates> {
  HSNCodeCubit() : super(CubitHsnLoading());

  Future<void> getHSNCodes() async {
    emit(CubitHsnLoading());
    try {
      final hsnCodes = await HSNCodeService().fetchItemHSN();

      emit(CubitHsnLoaded(hsns: hsnCodes));
    } catch (e) {
      emit(CubitHsnError(e.toString()));
    }
  }
}
