import 'package:billingsphere/auth/providers/login_provider.dart';
import 'package:billingsphere/auth/providers/signup_provider.dart';
import 'package:billingsphere/screens/foundation/signInScreen.dart';
import 'package:billingsphere/screens/foundation/signUp.dart';
import 'package:billingsphere/screens/home/home.dart';
import 'package:billingsphere/screens/splash/splashScreen.dart';
import 'package:billingsphere/views/DB_homepage.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/foundation/Login_screen_resposive.dart/loginScreen.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => LoginProvider(context),
                  child: const LoginScreen(),
                ));

      case SignUpScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => SignUpProvider(context),
                  child: const SignUpScreen(),
                ));

      case DBHomePage.routeName:
        return MaterialPageRoute(builder: (context) => const DBHomePage());

      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      default:
        return null;
    }
  }
}
