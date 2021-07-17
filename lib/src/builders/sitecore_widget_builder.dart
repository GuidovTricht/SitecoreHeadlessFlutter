import 'dart:async';

import 'package:child_builder/child_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Builder that builds dynamic widgets from JSON or other Map-like structures.
/// Applications can register their own types and builders through the
/// [SitecoreWidgetRegistry].
@immutable
abstract class SitecoreWidgetBuilder {
  /// Constructs the builder by stating whether the widget being built is a
  /// [PreferredSizeWidget] or not.
  SitecoreWidgetBuilder({
    this.preferredSizeWidget = false,
    required this.numSupportedChildren,
  }) : assert(numSupportedChildren >= -1);

  static final SitecoreWidgetData kDefaultChild = SitecoreWidgetData(
    args: const {},
    builder: () => SitecoreSizedBoxBuilder(),
    placeholders: null,
    dynamicKeys: const {},
    registry: SitecoreWidgetRegistry.instance,
    type: SitecoreSizedBoxBuilder.type,
  );

  static final Logger _logger = Logger('SitecoreWidgetBuilder');

  final bool preferredSizeWidget;
  final int numSupportedChildren;

  /// Builds the widget.  If there are dynamic keys on the [data] object, and
  /// the widget is not a [PreferredSizeWidget], then the returned widget will
  /// be wrapped by a stateful widget that will rebuild if any of the dynamic
  /// args change in value.
  @nonVirtual
  Widget build({
    required ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required SitecoreWidgetData data,
  }) {
    late Widget result;

    if (preferredSizeWidget == true || data.dynamicKeys.isNotEmpty != true) {
      result = _buildWidget(
        childBuilder: childBuilder,
        context: context,
        data: data,
      );
    } else {
      result = _SitecoreWidgetStateful(
        childBuilder: childBuilder,
        customBuilder: _buildWidget,
        data: data,
        key: ValueKey('sitecore_widget_stateful.${data.id}'),
      );
    }

    return result;
  }

  /// Custom builder that subclasses must override and implement to return the
  /// actual [Widget] to be placed on the tree.
  @visibleForOverriding
  Widget buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required SitecoreWidgetData data,
    Key? key,
  });

  Widget _buildWidget({
    required ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required SitecoreWidgetData data,
  }) {
    var key = ValueKey(data.id);

    var widget = runZonedGuarded(() {
      return buildCustom(
        childBuilder: childBuilder,
        context: context,
        data: data,
        key: key,
      );
    }, (e, stack) {
      _logger.severe('[ERROR]: Unable to build widget!!!', e, stack);
    });

    if (widget == null) {
      throw Exception('[ERROR]: Unable to build widget');
    }

    if (childBuilder != null) {
      widget = childBuilder(context, widget);
    }

    return widget;
  }
}

class _SitecoreWidgetStateful extends StatefulWidget {
  _SitecoreWidgetStateful({
    required this.childBuilder,
    required this.customBuilder,
    required this.data,
    Key? key,
  }) : super(key: key);

  final ChildWidgetBuilder? childBuilder;
  final Widget? Function({
    required ChildWidgetBuilder childBuilder,
    required BuildContext context,
    required SitecoreWidgetData data,
  }) customBuilder;
  final SitecoreWidgetData data;

  @override
  _SitecoreWidgetStatefulState createState() => _SitecoreWidgetStatefulState();
}

class _SitecoreWidgetStatefulState extends State<_SitecoreWidgetStateful> {
  static final Logger _logger = Logger('_SitecoreWidgetStatefulState');

  late SitecoreWidgetData _data;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _data = widget.data;

    _subscription = widget.data.registry.valueStream.listen((event) {
      if (_data.dynamicKeys.contains(event) == true) {
        _data = _data.recreate();
        if (mounted == true) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sub = runZonedGuarded(
        (() => _data.builder().buildCustom(
              childBuilder: widget.childBuilder,
              context: context,
              data: _data,
              key: ValueKey(_data.id),
            )), (e, stack) {
      _logger.severe('Error building widget: [${_data.type}].', e, stack);
    });

    if (widget.childBuilder != null) {
      sub = widget.childBuilder!(context, sub!);
    }

    return sub!;
  }
}
