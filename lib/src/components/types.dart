import 'dart:async';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

typedef SitecoreWidgetFunction = FutureOr<dynamic> Function({
  required List<dynamic>? args,
  required SitecoreWidgetRegistry registry,
});

typedef SitecoreWidgetBuilderBuilder = SitecoreWidgetBuilder? Function(
  dynamic map, {
  SitecoreWidgetRegistry? registry,
});

typedef DeferredBuilder = SitecoreWidgetBuilder Function(
  SitecoreWidgetBuilderBuilder builder,
);
