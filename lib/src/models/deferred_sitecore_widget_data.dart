import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';

/// A [SitecoreWidgetData] subclass that does not parse the JSON until the values
/// are needed.  This is used internally by the library for when widgets are
/// requested through a variable reference because the variable often won't
/// exist until after the first pass of the widget tree processing is completed.
class DeferredSitecoreWidgetData implements SitecoreWidgetData {
  DeferredSitecoreWidgetData({
    required String key,
    required SitecoreWidgetRegistry registry,
  })  : _key = key,
        _registry = registry;

  final String _key;
  final SitecoreWidgetRegistry _registry;

  SitecoreWidgetData? _data;

  @override
  SitecoreWidgetBuilder? get args => data.args;

  @override
  SitecoreWidgetBuilder Function() get builder => data.builder;

  @override
  Map<String, dynamic>? get placeholders => data.placeholders;

  SitecoreWidgetData get data {
    if (_data == null) {
      var data = _registry.getValue(_key);

      if (data is! SitecoreWidgetData) {
        throw Exception(
          'Unable to find SitecoreWidgetData for [$_key] on the registry',
        );
      }

      // It's an error for two exact SitecoreWidgetData objects to be in two places
      // on the tree.  To avoid that, we recreate the data object to effectively
      // clone it so it's a copy that gets placed on the tree and not the exact
      // widget.  Plus, this way the widget picks up any current dynamic values
      // rather than the outdated ones it might have been set up with.
      _data = data.recreate();
    }
    return _data!;
  }

  @override
  Set<String> get dynamicKeys => data.dynamicKeys;

  @override
  String get id => data.id;

  @override
  Widget build({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
  }) =>
      data.build(
        childBuilder: childBuilder,
        context: context,
      );

  @override
  SitecoreWidgetData copyWith({
    dynamic args,
    SitecoreWidgetBuilder? builder,
    Map<String, dynamic>? placeholders,
    Set<String>? dynamicKeys,
    String? id,
    SitecoreWidgetRegistry? registry,
    String? type,
  }) =>
      SitecoreWidgetData(
        args: args ?? this.args,
        builder: builder as SitecoreWidgetBuilder Function()? ?? this.builder,
        placeholders: placeholders ?? this.placeholders,
        dynamicKeys: dynamicKeys ?? this.dynamicKeys,
        id: id ?? this.id,
        registry: registry ?? this.registry,
        type: type ?? this.type,
      );

  @override
  SitecoreWidgetData recreate() => data.recreate();

  @override
  SitecoreWidgetRegistry get registry => _registry;

  @override
  Map<String, dynamic> toJson() => data.toJson();

  @override
  String get type => data.type;
}
