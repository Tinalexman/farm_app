import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:farm_app/misc/constants.dart';
import 'package:farm_app/misc/providers.dart';
import 'package:farm_app/pages/home/alerts.dart';
import 'package:farm_app/pages/home/home.dart';
import 'package:farm_app/pages/home/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    children = const [
      Home(),
      Alerts(),
      Settings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(dashboardIndexProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: children,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 104.h,
        width: 360.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Container(
            width: 360.w,
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27.r),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.11),
                  blurRadius: 44,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if(index != 0) {
                      ref.watch(dashboardIndexProvider.notifier).state = 0;
                    }
                  },
                  child: SizedBox(
                    height: 45.r,
                    child: AnimatedSwitcherFlip.flipX(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      key: ValueKey<bool>(index == 0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.home,
                            color: index == 0 ? primary : neutral,
                          ),
                          Text(
                            "Home",
                            style: context.textTheme.bodySmall!.copyWith(
                              color: index == 0 ? primary : neutral,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(index != 1) {
                      ref.watch(dashboardIndexProvider.notifier).state = 1;
                    }
                  },
                  child: SizedBox(
                    height: 45.r,
                    child: AnimatedSwitcherFlip.flipX(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      key: ValueKey<bool>(index == 1),
                      child: Column(
                        children: [
                          Icon(
                            Icons.crisis_alert,
                            color: index == 1 ? primary : neutral,
                          ),
                          Text(
                            "Alerts",
                            style: context.textTheme.bodySmall!.copyWith(
                              color: index == 1 ? primary : neutral,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(index != 2) {
                      ref.watch(dashboardIndexProvider.notifier).state = 2;
                    }
                  },
                  child: SizedBox(
                    height: 45.r,
                    child: AnimatedSwitcherFlip.flipX(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      key: ValueKey<bool>(index == 2),
                      child: Column(
                        children: [
                          Icon(
                            Icons.settings,
                            color: index == 2 ? primary : neutral,
                          ),
                          Text(
                            "Settings",
                            style: context.textTheme.bodySmall!.copyWith(
                              color: index == 2 ? primary : neutral,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
