import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Constants {
  // static String baseUrl =
  //     'https://billingsphere-backend-yogeshbhai-2.onrender.com/api';

  static String baseUrl = 'https://billing-sphere-backend.onrender.com/api';

  // static String baseUrl = 'http://192.168.0.107:4567/api';
  // static String baseUrl = 'https://65.1.89.63/api';

  static Widget loadingIndicator = Lottie.asset(
    'assets/lottie/loader.json',
    width: 120,
    height: 120,
    fit: BoxFit.cover,
  );
}

const double macbookHeight = 796;
const double macbookWidth = 1439;

class Screen {
  final BuildContext context;
  Screen(this.context);

  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;
  double get customWidth => width / macbookWidth;
  double get customHeight => height / macbookHeight;
  bool get isMobile => customWidth <= 0.64;
  bool get isTablet => !isMobile && width < 900;
  bool get isDesktop => !isMobile && !isTablet;
  double get tableWidthFactor {
    if (width > 400 && !isTablet) {
      return 2.25;
    } else if (isTablet) {
      return 1.75;
    }
    return 2.5;
  }
}
