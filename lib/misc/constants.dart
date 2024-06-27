import 'package:flutter/material.dart';


const Color primary = Color.fromRGBO(93, 176, 117, 1);
const Color secondary = Color.fromRGBO(130, 199, 132, 1);
const Color secondary2 = Color.fromRGBO(221, 247, 232, 1);
const Color tertiary = Color.fromRGBO(248, 231, 28, 1);
const Color neutral = Color.fromRGBO(51, 51, 51, 1);
const Color neutral2 = Color.fromRGBO(127, 131, 136, 1);
const Color neutral3 = Color.fromRGBO(219, 229, 223, 0.3);
const Color neutral4 = Color.fromRGBO(217, 217, 217, 1);


extension PathExtension on String {
  String get path => "/$this";
}

extension ContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}


