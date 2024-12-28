import 'package:find_iss/routes/router_name.dart';
import 'package:find_iss/screens/home_page/ui/home_page_ui.dart';
import 'package:find_iss/screens/sign_in/ui/sign_in_ui.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen/ui/splash_screen_ui.dart';

class RouterISSTracker {
  static Route<dynamic> generate(RouteSettings setting) {
    switch (setting.name) {
      case RouterName.signInScreen:
        return MaterialPageRoute(builder: (_) => const SignInUi());
      case RouterName.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomePageUi());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreenUi());
    }
  }
}
