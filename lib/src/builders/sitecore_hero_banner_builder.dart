import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SitecoreHeroBannerBuilder extends SitecoreWidgetBuilder {
  SitecoreHeroBannerBuilder({
    this.image,
    this.imageUrl,
    this.title,
    this.subtitle,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'HeroBanner';

  final dynamic image;
  final String? imageUrl;
  final String? title;
  final String? subtitle;

  static SitecoreHeroBannerBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecoreHeroBannerBuilder? result;
    if (map != null) {
      result = SitecoreHeroBannerBuilder(
        image: map["Image"],
        title: map["Title"]["value"],
        subtitle: map["Subtitle"]["value"],
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
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image(image: NetworkImage(image["value"]["src"])),
            Center(
              child: Column(
                children: [
                  Text(
                    title!.toUpperCase(),
                    style: GoogleFonts.ibmPlexMono(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    subtitle!.toUpperCase(),
                    style: GoogleFonts.ibmPlexMono(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
