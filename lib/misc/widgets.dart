import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:farm_app/misc/constants.dart';


const Widget loader = SpinKitFoldingCube(
  color: primary,
  size: 40,
);

class Popup extends StatelessWidget {
  const Popup({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: CenteredPopup(),
  );
}

class CenteredPopup extends StatelessWidget {
  const CenteredPopup({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: loader);
}

class ImageDialog extends StatelessWidget {
  final String text;
  final VoidCallback onProceed;

  const ImageDialog({
    super.key,
    required this.text,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: 220.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Text(
              "Note",
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              text,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onProceed();
                  },
                  child: Text(
                    "Proceed",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Montserrat",
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
