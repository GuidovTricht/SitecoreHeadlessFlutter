import 'package:flutter/material.dart';
import 'package:sitecore_flutter/pages/pages.dart';

class SitecoreRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (_) => DefaultPage(settings.name.toString()));
  }
}
