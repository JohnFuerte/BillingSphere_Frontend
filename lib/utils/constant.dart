import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Constants {
  static String baseUrl =
      'https://billingsphere-backend-yogeshbhai-2.onrender.com/api';

  // static String baseUrl = 'https://billing-sphere-backend.onrender.com/api';

  // static String baseUrl = 'http://192.168.0.135:4567/api';
  // static String baseUrl = 'https://65.1.89.63/api';

  static Widget loadingIndicator = Lottie.asset(
    'assets/lottie/loader.json',
    width: 120,
    height: 120,
    fit: BoxFit.cover,
  );
}
