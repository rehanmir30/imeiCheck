import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei/utils/colors.dart';


class AppTextStyles {
  static final String _fontPoppins = GoogleFonts.poppins().fontFamily!;


  /// size = 12
  /// color = black
  static TextStyle black12TextStyle = TextStyle(
    color: AppColors.kBlackTextColor,
    fontSize: 12.spMin,
    fontFamily: _fontPoppins,
  );

  /// size = 15
  /// color = black
  static TextStyle black15TextStyle = TextStyle(
    color: AppColors.kBlackTextColor,
    fontSize: 15.spMin,
    fontFamily: _fontPoppins,
  );

  /// size = 14
  /// color = black
  static TextStyle black14TextStyle = TextStyle(
    color: AppColors.kBlackTextColor,
    fontSize: 14.spMin,
    fontFamily: _fontPoppins,
  );

  /// size = 14
  /// color = black
  /// FontWeight = w600
  static TextStyle black14BoldTextStyle = TextStyle(
    color: AppColors.kBlackTextColor,
    fontSize: 14.spMin,
    fontWeight: FontWeight.w600,
    fontFamily: _fontPoppins,
  );

  /// size = 14
  /// color = pink
  /// FontWeight = w600
  static TextStyle pink14BoldTextStyle = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 14.spMin,
    fontWeight: FontWeight.w600,
    fontFamily: _fontPoppins,
  );

  /// size = 18
  /// color = black
  /// FontWeight = w600
  static TextStyle black18W600TextStyle = TextStyle(
    color: AppColors.kBlackColor,
    fontSize: 18.spMin,
    fontWeight: FontWeight.w600,
    fontFamily: _fontPoppins,
  );

  /// size = 30
  /// color = black
  /// FontWeight = Bold
  static TextStyle black30BoldTextStyle = TextStyle(
    color: AppColors.kBlackTextColor,
    fontSize: 30.spMin,
    fontWeight: FontWeight.w900,
    fontFamily: _fontPoppins,
  );

  /// size = 18
  /// color = white
  /// FontWeight = w600
  static TextStyle white18W600TextStyle = TextStyle(
    color: AppColors.kWhiteColor,
    fontSize: 18.spMin,
    fontWeight: FontWeight.w600,
    fontFamily: _fontPoppins,
  );

  /// size = 14
  /// color = white
  static TextStyle white14TextStyle = TextStyle(
    color: AppColors.kWhiteColor,
    fontSize: 14.spMin,
    fontFamily: _fontPoppins,
  );

  /// size = 12
  /// color = green
  static TextStyle green12TextStyle = TextStyle(
    color: AppColors.kGreenColor,
    fontSize: 12.spMin,
    fontWeight: FontWeight.bold,
    fontFamily: _fontPoppins,
  );

  /// size = 18
  /// color = primary
  /// FontWeight = w600
  static TextStyle primary18W600TextStyle = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 18.spMin,
    fontWeight: FontWeight.w600,
    fontFamily: _fontPoppins,
  );
  /// size = 16
  /// color = primary
  /// FontWeight = w700
  static TextStyle primary16W700TextStyle = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 18.spMin,
    fontWeight: FontWeight.w700,
    fontFamily: _fontPoppins,
  );

  /// size = 20
  /// color = primary
  /// FontWeight = bold
  static TextStyle primary20BoldTextStyle = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 20.spMin,
    fontWeight: FontWeight.bold,
    fontFamily: _fontPoppins,
  );
  /// size = 22
  /// color = primary
  /// FontWeight = bold
  static TextStyle primary22BoldTextStyle = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 22.spMin,
    fontWeight: FontWeight.bold,
    fontFamily: _fontPoppins,
  );


  /// size = 16
  /// color = grey
  /// weight = 400
  static TextStyle grey16w400TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.kGrayColor,
    fontSize: 16.spMin,
    fontFamily: _fontPoppins,
  );

  /// size = 12
  /// color = primary
  static TextStyle primary12TextStyle = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 12.spMin,
    fontWeight: FontWeight.bold,
    fontFamily: _fontPoppins,
  );

  /// size = 12
  /// color = red
  static TextStyle red12TextStyle = TextStyle(
    color: AppColors.kRedColor,
    fontSize: 12.spMin,
    fontWeight: FontWeight.bold,
    fontFamily: _fontPoppins,
  );

  /// size = 12
  /// color = blue
  static TextStyle blue12TextStyle = TextStyle(
    color: AppColors.kBlueColor,
    fontSize: 12.spMin,
    fontWeight: FontWeight.bold,
    fontFamily: _fontPoppins,
  );


}
