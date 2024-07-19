import 'dart:developer';

import 'package:dio/dio.dart';

const double connectionErrorCode = -1000, unknownErrorCode = -2000;

Dio createDio(String baseUrl) => Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'ngrok-skip-browser-warning': true,
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  ),
);

Future<double> getCurrentData(Dio dio) async {
  try {
    Response response = await dio.get("/temp");
    if (response.statusCode! == 200) {
      return (response.data["TempInCValue"] as num).toDouble();
    }
  } on DioException catch(e) {
    if(e.type == DioExceptionType.connectionError || e.type == DioExceptionType.badResponse) {
      log("DioException: ${e}");
      return connectionErrorCode;
    }
  }

  catch (e) {
    log("Unknown Error: $e");
  }
  
  return unknownErrorCode;
}
