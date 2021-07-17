import 'package:meta/meta.dart';

@immutable
class SitecoreWidgetRegexHelper {
  SitecoreWidgetRegexHelper._();

  static final dynamicVarRegex = RegExp(r'^\{\{\s*\S*\s*\}\}$');
  static final paramsRegex = RegExp(r'(\!?{{0,2}[^,\{\(\)\}]*\}{0,2})');
  static final varRegex = RegExp(r'^!?\{\{\s*\S*\s*\}\}$');

  static List<SitecoreWidgetParams>? parse(String? data) {
    List<SitecoreWidgetParams>? params;
    if (data?.isNotEmpty == true) {
      params = [];

      var group = varRegex.stringMatch(data!);
      if (group?.isNotEmpty == true) {
        params.add(
          SitecoreWidgetParams(
            isStatic: group!.startsWith('!'),
            isVariable: true,
            key: group
                .substring(group.startsWith('!') ? 3 : 2, group.length - 2)
                .trim(),
          ),
        );
      } else {
        params.add(SitecoreWidgetParams(key: data));
      }
    }

    return params;
  }
}

@immutable
class SitecoreWidgetParams {
  SitecoreWidgetParams({
    this.isDeferred = false,
    this.isStatic = false,
    this.isVariable = false,
    required this.key,
  }) : assert(key?.isNotEmpty == true);

  final bool isDeferred;
  final bool isStatic;
  final bool isVariable;
  final String? key;

  @override
  bool operator ==(other) {
    var result = false;
    if (other is SitecoreWidgetParams) {
      result = true;
      result = result && isDeferred == other.isDeferred;
      result = result && isStatic == other.isStatic;
      result = result && isVariable == other.isVariable;
      result = result && key == other.key;
    }

    return result;
  }

  @override
  int get hashCode => '$key.$isDeferred.$isStatic.$isVariable'.hashCode;

  @override
  String toString() =>
      'SitecoreWidgetParams{isDeferred: $isDeferred, isStatic: $isStatic, isVariable: $isVariable, key: "$key"}';
}
