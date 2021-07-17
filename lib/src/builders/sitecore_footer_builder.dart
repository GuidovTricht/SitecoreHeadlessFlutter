import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

class SitecoreFooterBuilder extends SitecoreWidgetBuilder {
  SitecoreFooterBuilder({
    this.footerText,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'Footer';

  final String? footerText;

  static SitecoreFooterBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecoreFooterBuilder? result;
    if (map != null) {
      result = SitecoreFooterBuilder(
        footerText: map["footerText"],
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
        children: [Text(footerText!)],
      );
}
