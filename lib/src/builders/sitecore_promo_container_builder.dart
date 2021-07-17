import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

class SitecorePromoContainerBuilder extends SitecoreWidgetBuilder {
  SitecorePromoContainerBuilder()
      : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'PromoContainer';

  static SitecorePromoContainerBuilder? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecorePromoContainerBuilder? result;
    if (map != null) {
      result = SitecorePromoContainerBuilder();
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
      SitecorePlaceholder(data.placeholders!["promos"]);
}
