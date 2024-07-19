import 'dart:async';
import 'dart:math' hide log;

import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:farm_app/api/base.dart';
import 'package:farm_app/misc/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../misc/widgets.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late Random random;
  late Timer timer;
  late List<double> temps;

  String condition = "";

  final String pigImage =
      "https://www.freepik.com/free-vector/hand-drawn-pig-cartoon-illustration_42077885.htm#page=2&query=pig&position=1&from_view=keyword&track=sph&uuid=15c8be26-d9c9-4306-9680-699264429bf7";

  bool pollForData = false, hasConnected = false;

  late Dio dio;

  @override
  void initState() {
    super.initState();
    random = Random(DateTime.now().millisecondsSinceEpoch);
    temps = [0];
    Future.delayed(Duration.zero, showServerDialog);
  }

  void setupTimer() {
    timer = Timer.periodic(const Duration(seconds: 10), processData);
    processData(timer);
  }

  Color get tempColor {
    double temperature = temps.last;
    if (temperature < 38.3) {
      return const Color.fromRGBO(60, 80, 180, 1);
    } else if (temperature >= 38.3 && temperature <= 39.7) {
      return const Color.fromRGBO(109, 178, 98, 1);
    } else if (temperature > 39.7 && temperature <= 41) {
      return const Color.fromRGBO(237, 167, 58, 1);
    }
    return const Color.fromRGBO(255, 82, 82, 1);
  }

  void copyPigUrl() => FlutterClipboard.copy(pigImage);

  double getNumRange(int min, int max) =>
      (random.nextInt(max - min) + min).toDouble();

  List<FlSpot> get randomSpots {
    int maxLength = 11;
    List<FlSpot> spots = [];
    if (temps.length < maxLength) {
      // If the temperatures are not up to the max length
      // Add all the valid temperatures
      spots.addAll(
        List.generate(
          temps.length,
          (index) => FlSpot(index.toDouble(), temps[index]),
        ),
      );
      // Add zeros for the rest
      spots.addAll(
        List.generate(
          maxLength - temps.length,
          (index) => FlSpot(
            (temps.length + index).toDouble(),
            0,
          ),
        ),
      );
    } else {
      List<double> lastTemps = temps
          .sublist(temps.length - maxLength); // Get the last 'max' temparatures
      spots.addAll(
        List.generate(
          maxLength,
          (index) => FlSpot(
            index.toDouble(),
            lastTemps[index],
          ),
        ),
      );
    }

    return spots;
  }

  void processData(Timer? timer) async {
    if (!pollForData) return;

    double value = await getCurrentData(dio);
    if (value == connectionErrorCode || value == unknownErrorCode) {
      Fluttertoast.showToast(
        msg: value == unknownErrorCode
            ? "An unknown error occurred. Please confirm the base url and check your internet settings or contact the developer."
            : "Unable to connect to the server. Please ensure the sensor is on and confirm the base url",
        backgroundColor: primary,
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14,
        textColor: Colors.white,
      );
      setState(() {
        pollForData = false;
        hasConnected = false;
      });
      showServerDialog();
      return;
    } else if (!hasConnected) {
      Fluttertoast.showToast(
        msg: "Connected to the server successfully",
        backgroundColor: primary,
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14,
        textColor: Colors.white,
      );
      setState(() => hasConnected = true);
    }

    double extra = 0;
    if (temps.length == 1 && temps.first == 0) {
      temps.setAll(0, [value + extra]);
    } else {
      temps.add(value + extra);
    }
    setState(() {
      if (value < 38.3) {
        condition = "";
      } else if (value >= 38.3 && value <= 39.7) {
        condition = "Normal";
      } else if (value > 39.7 && value <= 40.5) {
        condition = "Likely in heat";
      } else if (value > 40.5 && value < 45) {
        condition = "Likely sick";
      } else {
        condition = "";
      }
    });
  }

  void showServerDialog() {
    showDialog(
      context: context,
      builder: (_) => ServerUrlDialog(onProceed: (val) {
        if (val != null) {
          setState(() {
            dio = createDio(val);
            pollForData = true;
          });
          setupTimer();
        } else {
          Fluttertoast.showToast(
            msg: "User canceled server connection. Please restart the app",
            backgroundColor: primary,
            gravity: ToastGravity.SNACKBAR,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 14,
            textColor: Colors.white,
          );
        }
      }),
      useSafeArea: true,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Text(
                      "Animalia",
                      style: context.textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        color: primary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Check the health conditions of your animals easily with their temperatures.",
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: neutral2,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
              Image.asset(
                "assets/images/Pig.png",
                width: 360.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10.h),
              Center(
                child: GestureDetector(
                  onTap: copyPigUrl,
                  child: Text(
                    "Pig Image by Freepik",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "Statistics",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: neutral2,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Cody",
                              style: context.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Brand",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: neutral2,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Large White",
                              style: context.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Temperature",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: neutral2,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${temps.last.toStringAsFixed(1)}\u00B0C",
                              style: context.textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat",
                                color: tempColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              condition,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: tempColor,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      "Graph",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "X Axis ",
                          style: context.textTheme.bodySmall!.copyWith(
                            color: neutral2,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "(10 second updates)",
                          style: context.textTheme.bodySmall!.copyWith(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Y Axis ",
                          style: context.textTheme.bodySmall!.copyWith(
                            color: neutral2,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "(Temperature)",
                          style: context.textTheme.bodySmall!.copyWith(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              SizedBox(
                height: 400.h,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 90,
                    minX: 0,
                    maxX: 10,
                    clipData: const FlClipData.horizontal(),
                    backgroundColor: Colors.white,
                    gridData: const FlGridData(
                      drawHorizontalLine: false,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        color: primary,
                        gradient: const LinearGradient(
                          colors: [primary, secondary],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        belowBarData: BarAreaData(
                          color: primary,
                          show: true,
                          gradient: LinearGradient(
                            colors: [primary.withOpacity(0.5), Colors.white],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        shadow: Shadow(
                          color: primary.withOpacity(0.5),
                        ),
                        isCurved: true,
                        isStrokeCapRound: true,
                        curveSmoothness: 1,
                        spots: randomSpots,
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
