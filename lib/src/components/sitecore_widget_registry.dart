import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:sitecore_flutter/sitecore_dynamic_widget.dart';
import 'package:sitecore_flutter/src/builders/sitecore_promo_container_builder.dart';

class SitecoreWidgetRegistry {
  /// Constructs a one-off registry. This accepts an optional group of custom
  /// widget [builders], custom widget [functions], and widget [values].
  SitecoreWidgetRegistry({
    Map<String, JsonClassBuilder<Object>>? builders,
    this.debugLabel,
    this.disableValidation = false,
    Map<String, dynamic>? values,
  }) {
    _customBuilders
        .addAll(builders as Map<String, SitecoreWidgetBuilderContainer>? ?? {});
    _values.addAll(values ?? {});
  }

  static final SitecoreWidgetRegistry instance = SitecoreWidgetRegistry(
    debugLabel: 'default',
  );

  final _customBuilders = <String, SitecoreWidgetBuilderContainer>{};
  final String? debugLabel;
  final bool disableValidation;
  final _values = <String?, dynamic>{};
  final _internalBuilders = <String, SitecoreWidgetBuilderContainer>{
    SitecoreHeroBannerBuilder.type: SitecoreWidgetBuilderContainer(
        builder: SitecoreHeroBannerBuilder.fromDynamic),
    SitecorePromoContainerBuilder.type: SitecoreWidgetBuilderContainer(
        builder: SitecorePromoContainerBuilder.fromDynamic),
    SitecorePromoCardBuilder.type: SitecoreWidgetBuilderContainer(
        builder: SitecorePromoCardBuilder.fromDynamic),
    SitecoreSectionHeaderBuilder.type: SitecoreWidgetBuilderContainer(
        builder: SitecoreSectionHeaderBuilder.fromDynamic),
    SitecoreFooterBuilder.type: SitecoreWidgetBuilderContainer(
        builder: SitecoreFooterBuilder.fromDynamic),
  };
  final _internalValues = <String, dynamic>{}..addAll(
      CurvesValues.values,
    );

  /// Returns an unmodifiable reference to the internal set of values.
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  StreamController<String>? _valueStreamController =
      StreamController<String>.broadcast();

  /// Returns the [Stream] that an element can listen to in order to be notified
  /// when
  Stream<String?> get valueStream => _valueStreamController!.stream;

  /// Removes all variable values from the registry
  void clearValues() {
    var keys = Set<String>.from(_values.keys);
    _values.clear();

    keys.forEach((element) => _valueStreamController?.add(element));
  }

  /// Disposes the registry.
  void dispose() {
    _valueStreamController?.close();
    _valueStreamController = null;
  }

  /// Returns the variable value for the given [key].This will first check for
  /// a custom dynamic value using the [key], and if none is found, this will
  /// then check the internal values. If a variable with named [key] cannot be
  /// found, this will return [null].
  dynamic getValue(String? key) => _values[key] ?? _internalValues[key!];

  /// Returns the builder for the requested [type].  This will first search the
  /// registered custom builders, then if no builder is found, this will then
  /// search the library provided builders.
  ///
  /// If no builder is registered for the given [type] then this will throw an
  /// [Exception].
  SitecoreWidgetBuilderBuilder getWidgetBuilder(String type) {
    var container = _customBuilders[type] ?? _internalBuilders[type];
    if (container == null) {
      return PlaceholderBuilder.fromDynamic;
    }
    var builder = container.builder;

    return builder;
  }

  /// Processes any dynamic argument values from [args].  This will return a
  /// metadata object with the results as well as a collection of dynamic
  /// variable names that were encounted.
  DynamicParamsResult processDynamicArgs(
    dynamic args, {
    Set<String>? dynamicKeys,
  }) {
    dynamicKeys ??= <String>{};

    dynamic result;
    if (args is String) {
      var parsed = SitecoreWidgetRegexHelper.parse(args);

      if (parsed?.isNotEmpty == true) {
        List<dynamic>? functionArgs;
        for (var item in parsed!) {
          if (item.isVariable == true) {
            if (item.isStatic != true) {
              dynamicKeys.add(item.key!);
            }

            var value = getValue(item.key);
            functionArgs?.add(value);
            result = value;
          } else {
            functionArgs?.add(item.key);
            result = item.key;
          }
        }
      } else {
        result = args;
      }
    } else if (args is Iterable) {
      result = [];
      for (var value in args) {
        result.add(processDynamicArgs(
          value,
          dynamicKeys: dynamicKeys,
        ).values);
      }
    } else if (args is Map) {
      result = {};

      if (args['componentName'] != null &&
          (args['placeholders'] != null || args['fields'] != null)) {
        // The entry has a "componentName" and one of: "placeholders", "fields".  This
        // means the item is most like a SitecoreWidgetData class, so we should not
        // process the args yet.  We should wait until the actual SitecoreWidgetData
        // gets built.
        result = args;
      } else {
        args.forEach((key, value) {
          result[key] = processDynamicArgs(
            value,
            dynamicKeys: dynamicKeys,
          ).values;
        });
      }
    } else {
      result = args;
    }

    return DynamicParamsResult(
      dynamicKeys: dynamicKeys,
      values: result,
    );
  }

  /// Registers the widget type with the registry to that [type] can be used in
  /// custom forms.  Types registered by the application take precidence over
  /// built in registered builders.  This allows an application the ability to
  /// provide custom widgets even for built in form types.
  ///
  /// If the [container] has an associated schema id then in DEBUG builds, that
  /// schema will be used to validate the attributes sent to the builder.
  void registerCustomBuilder(
    String type,
    SitecoreWidgetBuilderContainer container,
  ) =>
      _customBuilders[type] = container;

  /// Registers the custom builders.  This is a convenience method that calls
  /// [registerCustomBuilder] for each entry in [containers].
  void registerCustomBuilders(
    Map<String, SitecoreWidgetBuilderContainer> containers,
  ) =>
      containers.forEach((key, value) => registerCustomBuilder(key, value));

  /// Removes the [key] from the registry.
  ///
  /// If, and only if, the [key] was registered on the registry will this fire
  /// an event on the [valueStream] with the [key] so listeners can be notified
  /// that the value has changed.
  dynamic removeValue(String key) {
    assert(key.isNotEmpty == true);

    var hasKey = _values.containsKey(key);
    var result = _values.remove(key);
    if (hasKey == true) {
      _valueStreamController?.add(key);
    }

    return result;
  }

  /// Sets the [value] for the [key] on the registry.  If the [value] is [null],
  /// this redirects to [removeValue].
  ///
  /// If the [value] is different than the current value for the [key] then this
  /// will fire an event on the [valueStream] with the [key] so listeners can be
  /// notified that it has changed.
  void setValue(
    String key,
    dynamic value,
  ) {
    assert(key.isNotEmpty == true);
    if (value == null) {
      removeValue(key);
    } else {
      var current = _values[key];
      if (current != value) {
        _values[key] = value;
        _valueStreamController?.add(key);
      }
    }
  }

  @override
  String toString() => 'SitecoreWidgetRegistry{$debugLabel}';

  /// Removes a registered [type] from the custom registry and returns the
  /// associated builder, if one exists.  If the [type] is not registered then
  /// this will [null].
  SitecoreWidgetBuilderContainer? unregisterCustomBuilder(String type) =>
      _customBuilders.remove(type);
}
