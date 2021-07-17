import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

class SitecorePlaceholder extends StatelessWidget {
  List<dynamic> content = [];

  SitecorePlaceholder(List<dynamic> jsonData) {
    content = jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (content != null) {
          List<Widget> list = [];
          for (var i = 0; i < content.length; i++) {
            var widget = SitecoreWidgetData.fromDynamic(content[i]);
            list.add(widget!.build(context: context));
          }
          return Container(child: Row(children: [Column(children: list)]));
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
