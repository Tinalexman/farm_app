import 'dart:developer';

import 'package:dio/dio.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: "https://af53-102-88-68-164.ngrok-free.app",
    headers: {
      'ngrok-skip-browser-warning': true,
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  ),
);

Future<void> getCurrentData() async {

  try {
    Response response = await dio.get("/temp");
    if (response.statusCode! == 200) {
      log(response.data.toString());
    }
  } catch (e) {
    log(e.toString());
  }
}
