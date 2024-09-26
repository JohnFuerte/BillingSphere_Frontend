import 'package:billingsphere/data/models/user/user_model.dart';

abstract class UserState {}

class UserInitailState extends UserState {}

class UserLoadingState extends UserState {}

class UserCreatedState extends UserState {
  final UserModel userModel;
  UserCreatedState(this.userModel);
}

class UserLoggedInState extends UserState {
  final UserModel userModel;
  UserLoggedInState(this.userModel);
}

class UserLoggedOutState extends UserState {}

class UserErrorState extends UserState {
  final String message;
  UserErrorState(this.message);
}
