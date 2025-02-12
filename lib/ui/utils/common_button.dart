import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CommonButton({
    super.key,
    this.text,
    this.onTap,
    this.height,
    this.width,
    this.color,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 40.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          text ?? '',
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16.sp,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
