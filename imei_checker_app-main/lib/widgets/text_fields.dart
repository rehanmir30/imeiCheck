import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_text_styles.dart';
import '../utils/colors.dart';
import '../utils/logger.dart';

class CustomTextFieldWithRectBorder extends StatelessWidget {
  const CustomTextFieldWithRectBorder({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.textInputType,
    this.textInputFormatters,
    this.onChanged,
    this.hintTextStyle,
    this.labelTextStyle,
    this.enableBorderColor,
    this.focusBorderColor = AppColors.kPrimary,
    this.prefixIconFocusColor = AppColors.kBlackTextColor,
    this.maxlines,
    this.minlines,
    this.enabledBorderRadius = 30,
    this.focusedBorderRadius = 30,
    this.contentPadding,
    this.prefixConstraints,
    this.suffixIconConstraints,
    this.enabledBorderWidht = 1,
    this.focusedBorderWidht = 1,
    this.textFieldTextStyle,
    this.filledColor,
    this.focusNode,
    this.readOnly,
    this.obscureText = false,
    this.onTap,
    this.filled = false,
    this.autofocus = false,
    this.cursorColor,
  });
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final bool autofocus;
  final List<TextInputFormatter>? textInputFormatters;
  final void Function(String)? onChanged;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final Color? enableBorderColor;
  final Color focusBorderColor;
  final Color prefixIconFocusColor;
  final Color? cursorColor;
  final int? maxlines;
  final int? minlines;
  final double enabledBorderRadius;
  final double focusedBorderRadius;
  final EdgeInsets? contentPadding;
  final BoxConstraints? prefixConstraints;
  final BoxConstraints? suffixIconConstraints;
  final double enabledBorderWidht;
  final double focusedBorderWidht;
  final TextStyle? textFieldTextStyle;
  final bool? filled;
  final Color? filledColor;
  final FocusNode? focusNode;
  final bool? readOnly;
  final bool obscureText;
  final Function()? onTap;

  final String tag = "CustomTextFieldWithRectBorder";

  @override
  Widget build(BuildContext context) {
    Logger.info(tag, "Inside build");
    return Theme(
      data: ThemeData(
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: prefixIconFocusColor)),
      child: TextFormField(
        onTap: onTap,
        key: key,
        readOnly: readOnly ?? false,
        obscureText: obscureText,
        controller: controller,
        autofocus: autofocus,
        focusNode: focusNode,
        cursorColor: cursorColor ?? AppColors.kPrimary,
        inputFormatters: textInputFormatters,
        style: textFieldTextStyle ?? AppTextStyles.black14TextStyle,
        keyboardType: textInputType ?? TextInputType.text,
        maxLines: maxlines ?? 1,
        minLines: minlines,
        onChanged: (value) {
          if (onChanged != null) return onChanged!(value);
        },
        decoration: InputDecoration(
          isDense: true,
          labelText: labelText,
          labelStyle: labelTextStyle ?? AppTextStyles.grey16w400TextStyle,
          hintText: hintText ?? '',
          hintStyle: hintTextStyle ?? AppTextStyles.grey16w400TextStyle,
          prefix: prefix,
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixConstraints,
          contentPadding: contentPadding,
          suffixIcon: suffixIcon,
          suffix: suffix,
          suffixIconConstraints: suffixIconConstraints,
          fillColor: filledColor ?? AppColors.kWhiteColor,
          filled: filled,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(enabledBorderRadius),
            borderSide: BorderSide(
                color: enableBorderColor ?? AppColors.kPrimary,
                width: enabledBorderWidht),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(focusedBorderRadius),
            borderSide: BorderSide(
              color: focusBorderColor,
              width: focusedBorderWidht,
            ),
          ),
        ),
      ),
    );
  }
}

