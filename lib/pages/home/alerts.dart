import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farm_app/components/cow.dart';
import 'package:farm_app/misc/constants.dart';
import 'package:farm_app/misc/providers.dart';

class Alerts extends ConsumerStatefulWidget {
  const Alerts({super.key});

  @override
  ConsumerState<Alerts> createState() => _AlertsState();
}

class _AlertsState extends ConsumerState<Alerts> {
  final List<String> tabs = ["All", "Sick", "Hungry"];

  int tabState = 0;

  int get totalItems {
    if (tabState == 0) {
      return ref.watch(allCowsProvider).length + 1;
    } else if (tabState == 1) {
      return ref.watch(sickCowsProvider).length + 1;
    } else if (tabState == 2) {
      return ref.watch(hungryCowsProvider).length + 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Cow> allCows = ref.watch(allCowsProvider);
    List<Cow> sickCows = ref.watch(sickCowsProvider);
    List<Cow> hungryCows = ref.watch(hungryCowsProvider);

    return Column(
      children: [
        Container(
          width: 360.w,
          height: 180.h,
          padding: EdgeInsets.only(
            left: 28.w,
            right: 28.w,
            bottom: 21.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.11),
                blurRadius: 44,
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alerts",
                style: context.textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                  color: neutral,
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
              SizedBox(height: 20.h),
              Container(
                width: 360.w,
                height: 60.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 19.w,
                ),
                decoration: BoxDecoration(
                  color: neutral3,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    tabs.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() => tabState = index),
                      child: Container(
                        width: 75.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: tabState == index ? secondary2 : null,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          tabs[index],
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: tabState == index ? primary : neutral2,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 29.w),
            child: ListView.separated(
              itemBuilder: (_, index) {
                if (index == totalItems - 1) {
                  return SizedBox(height: 150.h);
                }

                late Cow cow;
                if (tabState == 0) {
                  cow = allCows[index];
                } else if (tabState == 1) {
                  cow = sickCows[index];
                } else if (tabState == 2) {
                  cow = hungryCows[index];
                }

                return _CowContainer(cow: cow);
              },
              separatorBuilder: (_, index) => index == totalItems - 2
                  ? const SizedBox()
                  : Column(
                      children: [
                        SizedBox(height: 5.h),
                        Divider(
                          color: neutral4,
                          thickness: 1.5.h,
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
              itemCount: totalItems,
              physics: const BouncingScrollPhysics(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CowContainer extends StatelessWidget {
  final Cow cow;

  const _CowContainer({
    super.key,
    required this.cow,
  });

  Color get tempColor {
    if (cow.temperature < 45) {
      return const Color.fromRGBO(109, 178, 98, 1);
    } else if (cow.temperature >= 45 && cow.temperature < 70) {
      return const Color.fromRGBO(237, 167, 58, 1);
    }
    return const Color.fromRGBO(255, 82, 82, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: secondary2,
              ),
              child: Image.asset("assets/images/Cow.png"),
            ),
            SizedBox(width: 23.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cow.name,
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    color: neutral,
                  ),
                ),
                Text(
                  cow.brand,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: neutral2,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )
          ],
        ),
        Text(
          "${cow.temperature}\u00B0",
          style: context.textTheme.titleMedium!.copyWith(
            color: tempColor,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
