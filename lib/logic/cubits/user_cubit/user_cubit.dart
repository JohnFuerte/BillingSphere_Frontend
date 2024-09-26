import 'package:billingsphere/data/models/user/user_model.dart';
import 'package:billingsphere/data/repository/user_repository.dart';
import 'package:billingsphere/logic/cubits/user_cubit/user_state.dart';
import 'package:billingsphere/logic/services/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitailState()) {
    _initialize();
  }

  final UserRepository _userRepository = UserRepository();

  void _initialize() async {
    final userDetails = await Preferences.fetchUserDetails();
    String? email = userDetails["email"];
    String? password = userDetails["password"];

    if (email == null || password == null) {
      emit(UserLoggedOutState());
    } else {
      signIn(email: email, password: password);
    }
  }

  void _emitLoggedInState(
      {required UserModel userModel,
      required String email,
      required String password}) async {
    await Preferences.saveUserDetails(email, password);
    emit(UserLoggedInState(userModel));
  }

  void _emitCreatedState({
    required UserModel userModel,
    required String email,
    required String password,
  }) async {
    await Preferences.saveUserDetails(email, password);
    emit(UserCreatedState(userModel));
  }

  //For SignIn
  void signIn({
    required String email,
    required String password,
  }) async {
    emit(UserLoadingState());
    try {
      UserModel userModel =
          await _userRepository.signIn(email: email, password: password);
      _emitLoggedInState(
          userModel: userModel, email: email, password: password);
    } catch (ex) {
      print(ex.toString());
      emit(UserErrorState(ex.toString()));
    }
  }

  //For Creating Account
  void createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(UserLoadingState());
    try {
      UserModel userModel = await _userRepository.createAccount(
          email: email, password: password, name: name);
      _emitCreatedState(userModel: userModel, email: email, password: password);
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
    }
  }

  //For Logging out to user

  void signOut() async {
    await Preferences.clear();
    emit(UserLoggedOutState());
  }
}
