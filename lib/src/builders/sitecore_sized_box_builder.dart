import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

class SitecoreSizedBoxBuilder extends SitecoreWidgetBuilder {
  SitecoreSizedBoxBuilder({
    this.height,
    this.width,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 1;
  static const type = 'sized_box';

  final double? height;
  final double? width;

  static SitecoreSizedBoxBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecoreSizedBoxBuilder? result;
    if (map != null) {
      result = SitecoreSizedBoxBuilder(
        height: JsonClass.parseDouble(map['height']),
        width: JsonClass.parseDouble(map['width']),
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
    return SizedBox(height: height, key: key, width: width);
  }
}
