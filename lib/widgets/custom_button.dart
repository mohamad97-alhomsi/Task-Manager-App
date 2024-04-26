import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.width,
      this.height,
      required this.text,
      required this.onPressed,
      this.radius,
      this.backgroundColor,
      this.foregroundColor,
      this.fontSize,
      this.arabicFontSize,
      this.arabicFontWeight,
      this.fontWeight,
      this.borderColor,
      this.textStyle,
      this.isEnabled = true,
      this.customIcon});
  final String text;
  final double? width;
  final double? height;
  final void Function() onPressed;
  final double? radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final double? arabicFontSize;
  final FontWeight? arabicFontWeight;
  final FontWeight? fontWeight;
  final bool isEnabled;
  final Color? borderColor;
  final Widget? customIcon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          
            style: OutlinedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
                backgroundColor: backgroundColor,
                side: borderColor == null
                    ? null
                    : BorderSide(color: borderColor!),
                shape: radius == null
                    ? null
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius!)),
                foregroundColor: foregroundColor),
            onPressed: isEnabled == true ? onPressed : null,
            child: FittedBox(
              child: Text(
                text,
                style: textStyle,
              ),
            )),
      ),
    );
  }
}
