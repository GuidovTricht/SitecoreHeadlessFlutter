import 'package:meta/meta.dart';

@immutable
class SitecoreWidgetType {
  const SitecoreWidgetType(
    this.code, {
    this.skipDeepArgs,
  });

  final String code;
  final Set<String>? skipDeepArgs;

  @override
  bool operator ==(other) {
    var result = false;

    if (other is SitecoreWidgetType) {
      result = other.code == code;
    }

    return result;
  }

  @override
  int get hashCode => code.hashCode;
}
