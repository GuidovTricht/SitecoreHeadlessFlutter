import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:flutter_html/flutter_html.dart';

class SitecorePromoCardBuilder extends SitecoreWidgetBuilder {
  SitecorePromoCardBuilder({
    this.image,
    this.text,
    this.headline,
    this.link,
    this.link_text,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'PromoCard';

  final dynamic image;
  final String? link;
  final String? link_text;
  final String? text;
  final String? headline;

  static SitecorePromoCardBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecorePromoCardBuilder? result;
    if (map != null) {
      String? text = map["Link"]["value"]["text"];
      result = SitecorePromoCardBuilder(
        image: map["Image"],
        link: map["Link"]["value"]["href"],
        link_text: text!.isEmpty ? "Open" : text,
        text: map["Text"]["value"],
        headline: map["Headline"]["value"],
      );
    }
    return result;
  }

  @override
  Widget buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required SitecoreWidgetData data,
    Key? key,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, link!);
        },
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Card(
              elevation: 0.7,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(image: NetworkImage(image["value"]["src"])),
                  Text(
                    headline!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Html(
                    data: text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
