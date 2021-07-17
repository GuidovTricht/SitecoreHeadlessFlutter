import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SitecoreSectionHeaderBuilder extends SitecoreWidgetBuilder {
  SitecoreSectionHeaderBuilder({
    this.text,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'SectionHeader';

  final String? text;

  static SitecoreSectionHeaderBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecoreSectionHeaderBuilder? result;
    if (map != null) {
      result = SitecoreSectionHeaderBuilder(
        text: map["Text"]["value"],
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
  }) =>
      Row(
        children: [
          Text(
            text!.toUpperCase(),
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.w600),
          )
        ],
      );
}
