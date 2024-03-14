import 'package:flutter/material.dart';

import '../screen/homeContainer/home_container.dart';
import '../screen/login/login_screen.dart';

class NavRoute {
  static MaterialPageRoute<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routePath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case HomeContainer.routePath:
        return MaterialPageRoute(builder: (_) => const HomeContainer());
      default:
        return errorRoute();
    }
  }
}

errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return const Scaffold(
      body: Center(
        child: Text('Undefined route'),
      ),
    );
  });
}
