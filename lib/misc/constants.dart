import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


const Color primary = Color.fromRGBO(93, 176, 117, 1);
const Color secondary = Color.fromRGBO(130, 199, 132, 1);
const Color tertiary = Color.fromRGBO(248, 231, 28, 1);
const Color neutral = Color.fromRGBO(51, 51, 51, 1);


extension PathExtension on String {
  String get path => "/$this";
}

extension ContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  GoRouter get router => GoRouter.of(this);
}

class Pages {
  static String get home => "home";
}


