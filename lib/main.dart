import 'package:farm_app/pages/home/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await ScreenUtil.ensureScreenSize();

  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (_) =>
    const FarmApp(),
    // ),
  );
}

class FarmApp extends StatefulWidget {
  const FarmApp({super.key});

  @override
  State<FarmApp> createState() => _FarmAppState();
}

class _FarmAppState extends State<FarmApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => const MaterialApp(
        title: 'Farm App',
        themeMode: ThemeMode.light,
        home: Alerts(),
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
      ),
      splitScreenMode: true,
      ensureScreenSize: true,
      useInheritedMediaQuery: true,
      designSize: const Size(360, 800),
      minTextAdapt: true,
    );
  }
}
