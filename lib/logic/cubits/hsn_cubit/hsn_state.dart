import '../../../data/models/hsn/hsn_model.dart';

abstract class CubitHsnStates {}

class CubitHsnLoading extends CubitHsnStates {}

class CubitHsnLoaded extends CubitHsnStates {
  List<HSNCode> hsns;
  CubitHsnLoaded({required this.hsns});
}

class CubitHsnError extends CubitHsnStates {
  String error;
  CubitHsnError(this.error);
}
