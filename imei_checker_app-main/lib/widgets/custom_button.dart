import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final double? buttonHeight;
  final double? buttonWidth;
  final String? buttonText;
  final Color? buttonColor;
  final TextStyle? buttonTextStyle;
  final VoidCallback? buttonOnPressed;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton(
      {this.buttonText,
      this.buttonHeight,
       this.buttonColor,
      this.buttonWidth,
      this.buttonOnPressed,
      this.buttonTextStyle,
      this.borderRadius,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: buttonOnPressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? AppColors.kPrimary,
            animationDuration: const Duration(seconds: 1),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ??  BorderRadius.circular(30.0).r

            ),
          ),
          child: buttonText == null
              ? const SizedBox.shrink()
              : Text(
                  buttonText ?? '',
                  style: buttonTextStyle,
                ),
        ));
  }
}
