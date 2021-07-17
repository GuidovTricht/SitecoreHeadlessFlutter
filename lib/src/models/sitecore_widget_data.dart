import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class SitecoreWidgetData extends JsonClass {
  SitecoreWidgetData({
    dynamic args,
    required this.builder,
    Map<String, dynamic>? placeholders,
    Set<String>? dynamicKeys,
    String? id,
    SitecoreWidgetRegistry? registry,
    required this.type,
  })  : args = args,
        placeholders = placeholders,
        dynamicKeys = dynamicKeys ?? <String>{},
        id = id ?? Uuid().v4(),
        registry = registry ?? SitecoreWidgetRegistry.instance;

  static final Logger _logger = Logger('SitecoreWidgetData');

  final dynamic args;
  final SitecoreWidgetBuilder Function() builder;
  final Map<String, dynamic>? placeholders;
  final Set<String> dynamicKeys;
  final String id;
  final SitecoreWidgetRegistry registry;
  final String type;

  /// Decodes a JSON object into a dynamic widget.  The structure is the same
  /// for all dynamic widgets with the exception of the `args` value.  The
  /// `args` depends on the specific `type`.
  ///
  /// In the given JSON object, only the `child` or the `children` can be passed
  /// in; not both.  From an implementation perspective, there is no difference
  /// between passing in a `child` or a `children` with a single element, this
  /// will treat both of those identically.
  ///
  /// ```json
  /// {
  ///   "componentName": <String>,
  ///   "fields": <dynamic>,
  ///   "params": <dynamic>,
  ///   "placeholders": <SitecoreWidgetData[]>,
  ///   "uid": <String>
  /// }
  /// ```
  static SitecoreWidgetData? fromDynamic(
    dynamic map, {
    SitecoreWidgetRegistry? registry,
  }) {
    SitecoreWidgetData? result;
    var innerRegistry = registry ?? SitecoreWidgetRegistry.instance;

    if (map is String && map.startsWith('{{') && map.endsWith('}}')) {
      var key = map.substring(2, map.length - 2).trim();
      result = DeferredSitecoreWidgetData(
        key: key,
        registry: innerRegistry,
      );
    } else if (map != null) {
      var type = map['componentName'];
      var builder = innerRegistry.getWidgetBuilder(type);
      var fields = map['fields'];
      Map<String, dynamic> placeholders =
          map['placeholders'] ?? Map<String, dynamic>();

      var dynamicParamsResult =
          innerRegistry.processDynamicArgs(fields ?? <String, dynamic>{});

      try {
        result = SitecoreWidgetData(
          args: map['fields'] ?? {},
          builder: () {
            return builder(
              innerRegistry
                  .processDynamicArgs(fields ?? <String, dynamic>{})
                  .values,
              registry: registry,
            )!;
          },
          placeholders: placeholders,
          dynamicKeys: dynamicParamsResult.dynamicKeys,
          id: map['uid'],
          registry: innerRegistry,
          type: type,
        );
      } catch (e, stack) {
        if (e is _HandledJsonWidgetException) {
          rethrow;
        }
        _logger.severe('Error parsing data:\n$map', e, stack);
        throw _HandledJsonWidgetException(e, stack);
      }
    }

    return result;
  }

  /// Convenience method that can build the widget this data object represents.
  /// This is the equilivant of calling: [builder.build] and padding this in as
  /// the [data] parameter.
  Widget build({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
  }) {
    return builder().build(
      childBuilder: childBuilder,
      context: context,
      data: this,
    );
  }

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

  /// Recreates the data object based on the updated values and function
  /// responces from the registry.  This should only be called within the
  /// framework itself, external code should not need to call this.
  SitecoreWidgetData recreate() {
    var builder = registry.getWidgetBuilder(type);
    var dynamicParamsResult = registry.processDynamicArgs(args);

    return SitecoreWidgetData(
      args: args,
      builder: () {
        return builder(
          registry.processDynamicArgs(args ?? <String, dynamic>{}).values,
          registry: registry,
        )!;
      },
      placeholders: placeholders,
      dynamicKeys: dynamicParamsResult.dynamicKeys,
      id: id,
      registry: registry,
      type: type,
    );
  }

  @override
  Map<String, dynamic> toJson() => JsonClass.removeNull({
        'type': type,
        'id': id,
        'args': args,
        'placeholders': placeholders.toString(),
      });
}

@immutable
class _HandledJsonWidgetException implements Exception {
  _HandledJsonWidgetException(this.e, this.stack);

  final dynamic e;
  final StackTrace stack;
}
