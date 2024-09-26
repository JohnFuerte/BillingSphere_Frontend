import 'dart:async';

import 'package:billingsphere/helper/constants.dart';
import 'package:billingsphere/logic/cubits/user_cubit/user_cubit.dart';
import 'package:billingsphere/logic/cubits/user_cubit/user_state.dart';
import 'package:billingsphere/screens/foundation/signInScreen.dart';
import 'package:billingsphere/views/DB_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../foundation/Login_screen_resposive.dart/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 100), () {
      goToNextScreen();
    });

    super.initState();
  }

  //For checking user already logged in or user is first time trying login
  void goToNextScreen() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;

    if (userState is UserCreatedState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else if (userState is UserLoggedInState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, DBHomePage.routeName);
    } else if (userState is UserLoggedOutState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else if (userState is UserErrorState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        goToNextScreen();
      },
      child:Container()
    );
  }
}
