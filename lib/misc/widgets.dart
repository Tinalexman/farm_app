import 'package:farm_app/misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef StringCallback = void Function(String?);

class SpecialForm extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final bool obscure;
  final bool autoValidate;
  final FocusNode? focus;
  final bool autoFocus;
  final Function? onChange;
  final Function? onActionPressed;
  final Function? onValidate;
  final Function? onSave;
  final BorderRadius? radius;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final TextStyle? hintStyle;
  final bool readOnly;
  final int? maxLines;
  final double width;
  final double height;

  const SpecialForm({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    this.fillColor,
    this.borderColor,
    this.padding,
    this.hintStyle,
    this.focus,
    this.autoFocus = false,
    this.readOnly = false,
    this.obscure = false,
    this.autoValidate = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.none,
    this.onActionPressed,
    this.onChange,
    this.onValidate,
    this.onSave,
    this.radius,
    this.hint,
    this.prefix,
    this.suffix,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        autovalidateMode:
            autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        maxLines: maxLines,
        focusNode: focus,
        autofocus: autoFocus,
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        textInputAction: action,
        readOnly: readOnly,
        onEditingComplete: () {
          if (onActionPressed != null) {
            onActionPressed!(controller.text);
          }
        },
        cursorColor: primary,
        style:
            context.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          errorMaxLines: 1,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          fillColor: Colors.grey[200],
          filled: true,
          contentPadding: padding ??
              EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: maxLines == 1 ? 5.h : 10.h,
              ),
          prefixIcon: prefix != null
              ? SizedBox(
                  width: height,
                  height: height,
                  child: Center(
                    child: prefix,
                  ),
                )
              : null,
          suffixIcon: suffix != null
              ? SizedBox(
                  width: height,
                  height: height,
                  child: Center(child: suffix),
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5.r),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5.r),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: hintStyle ??
              context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w300,
                color: Colors.black45,
              ),
        ),
        onChanged: (value) {
          if (onChange == null) return;
          onChange!(value);
        },
        validator: (value) {
          if (onValidate == null) return null;
          return onValidate!(value);
        },
        onSaved: (value) {
          if (onSave == null) return;
          onSave!(value);
        },
      ),
    );
  }
}

class ServerUrlDialog extends StatefulWidget {
  final StringCallback onProceed;

  const ServerUrlDialog({
    super.key,
    required this.onProceed,
  });

  @override
  State<ServerUrlDialog> createState() => _ServerUrlDialogState();
}

class _ServerUrlDialogState extends State<ServerUrlDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
            SizedBox(height: 10.h),
            Text(
              "Server Base URL",
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Please confirm the base url to the server.",
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            SpecialForm(
              controller: controller,
              width: 360.w,
              height: 50.h,
              maxLines: 1,
              hint: "https://path-to-server",
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onProceed(null);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onProceed(controller.text.trim());
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Proceed",
                    style: context.textTheme.bodyLarge!.copyWith(
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
