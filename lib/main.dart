import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sitecore_flutter/app.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  runApp(App());
}
