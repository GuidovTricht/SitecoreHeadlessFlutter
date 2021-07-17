import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:sitecore_flutter/utils/utils.dart';
import 'package:sitecore_flutter/sitecore_headless/sitecore_headless.dart';
import 'package:sitecore_flutter/widgets/widgets.dart';

class DefaultPage extends StatefulWidget {
  String path = '/';
  RegExp isoFourLangRegex = new RegExp(r"^\/[a-z]{2}-[A-Z]{2}");
  RegExp isoTwoLangRegex = new RegExp(r"^\/[a-z]{2}");

  DefaultPage(String _path) {
    path = _path;
    path =
        path.replaceAll(isoFourLangRegex, '').replaceAll(isoTwoLangRegex, '');
  }

  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Response> response) {
        if (response.hasData) {
          var widgetJson = response.data!.json();
          var contextJson = widgetJson["sitecore"]["context"];
          var routeJson = widgetJson["sitecore"]["route"];
          return Scaffold(
            appBar: AppBar(
              title: Text(routeJson["displayName"].toString()),
            ),
            drawer: MaterialDrawer(
                currentPage: routeJson["displayName"].toString()),
            body: SingleChildScrollView(
              child: SitecorePlaceholder(routeJson["placeholders"]["main"]),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: _getWidget(),
    );
  }

  Future<Response> _getWidget() async {
    return await SitecoreLayoutServiceClient().requestLayout(widget.path);
  }
}
