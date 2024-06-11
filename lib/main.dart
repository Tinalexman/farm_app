import 'package:farm_app/misc/constants.dart';
import 'package:farm_app/misc/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await ScreenUtil.ensureScreenSize();

  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (_) =>
    const ProviderScope(child: FarmApp()),
    // ),
  );
}

class FarmApp extends StatefulWidget {
  const FarmApp({super.key});

  @override
  State<FarmApp> createState() => _FarmAppState();
}

class _FarmAppState extends State<FarmApp> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      initialLocation: Pages.home.path,
      routes: routes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => MaterialApp.router(
        title: 'Farm App',
        themeMode: ThemeMode.system,
        theme: FlexColorScheme.light(
          scheme: FlexScheme.greenM3,
          fontFamily: "Montserrat",
          useMaterial3: true,
          scaffoldBackground: const Color.fromARGB(255, 247, 247, 247),
          bottomAppBarElevation: 0.0,
          appBarElevation: 0.0,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          surfaceTint: Colors.transparent,
          background: const Color.fromARGB(255, 247, 247, 247),
        ).toTheme,
        darkTheme: FlexColorScheme.light(
          scheme: FlexScheme.greenM3,
          fontFamily: "Montserrat",
          useMaterial3: true,
          scaffoldBackground: const Color.fromARGB(255, 247, 247, 247),
          bottomAppBarElevation: 0.0,
          appBarElevation: 0.0,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
        ).toTheme,
        routerConfig: router,
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
