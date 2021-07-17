import 'package:flutter/material.dart';
import 'package:sitecore_flutter/utils/utils.dart';

class App extends MaterialApp {
  App()
      : super(
          initialRoute: '/',
          onGenerateRoute: SitecoreRouter.generateRoute,
        );
}
