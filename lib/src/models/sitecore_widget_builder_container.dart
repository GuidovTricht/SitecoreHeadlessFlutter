import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

/// Container for a [SitecoreWidgetBuilder] builder as well as an associated schema id.
class SitecoreWidgetBuilderContainer {
  SitecoreWidgetBuilderContainer({required this.builder});

  /// The builder that will create the [SitecoreWidgetBuilder] from JSON.
  final SitecoreWidgetBuilderBuilder builder;
}
