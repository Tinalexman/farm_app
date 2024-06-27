import 'dart:developer';

import 'package:dio/dio.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: "https://f39c-102-88-82-120.ngrok-free.app",
    headers: {
      'ngrok-skip-browser-warning': true,
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  ),
);

Future<double> getCurrentData() async {
  try {
    Response response = await dio.get("/temp");
    if (response.statusCode! == 200) {
      return (response.data["TempInCValue"] as num).toDouble();
    }
  } catch (e) {
    log(e.toString());
  }
  
  return 0;
}
