import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

class PlaceholderBuilder extends SitecoreWidgetBuilder {
  PlaceholderBuilder() : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = ''; //only used for dummy components

  static PlaceholderBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    PlaceholderBuilder? result;
    if (map != null) {
      result = PlaceholderBuilder();
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
      Placeholder(
        fallbackWidth: MediaQuery.of(context).size.width,
      );
}
