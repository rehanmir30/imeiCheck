import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:imei/utils/app_text_styles.dart';

import '../utils/colors.dart';

class AppWidgets {
  static bool _isDialogOpen = false;

  static Widget spacingHeight(double height) {
    return height.verticalSpace;
  }

  static Widget spacingWidth(double width) {
    return width.horizontalSpace;
  }

  static Widget sizedBoxWidget({double? width, double? height, Widget? child, Key? key}) {
    return SizedBox(
      height: height?.h,
      width: width?.w,
      key: key,
      child: child,
    );
  }

  static Widget text(String data, {TextStyle? style, int? maxLines, TextOverflow? overflow, TextAlign? textAlign}) {
    return Text(
      data,
      style: style ?? AppTextStyles.black18W600TextStyle,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      strutStyle: StrutStyle(forceStrutHeight: true, fontSize: style?.fontSize ?? AppTextStyles.black14TextStyle.fontSize),
    );
  }

  static Widget cachedNetworkImage(String imageUrl, {double? height, double? width, BoxFit? fit, Color? color}) {
    return CachedNetworkImage(
        errorWidget: (context, url, error) {
          return Container();
        },
        imageUrl: imageUrl,
        height: height?.h,
        width: width?.w,
        fit: fit,
        color: color);
  }

  static Widget assetImage(String assetUrl, {double? height, double? width, BoxFit? fit, Color? color, AlignmentGeometry? alignment}) {
    return image(assetUrl, height: height, width: width, fit: fit, color: color, alignment: alignment);
  }

  static Image image(String assetUrl, {double? height, double? width, BoxFit? fit, Color? color, AlignmentGeometry? alignment}) {
    return Image.asset(
      assetUrl,
      height: height?.r,
      width: width?.r,
      fit: fit,
      color: color,
      alignment: alignment ?? Alignment.center,
    );
  }

  static SvgPicture imageSVG(String assetUrl, {double? height, double? width, BoxFit? fit, Color? color, AlignmentGeometry? alignment}) {
    return SvgPicture.asset(
      assetUrl,
      height: height?.r,
      width: width?.r,
      fit: fit ?? BoxFit.contain,
      color: color,
      alignment: alignment ?? Alignment.center,
    );
  }

  /// size defaults to 24
  static Widget icon(IconData icon, {double size = 24, Color? color}) {
    return Icon(icon, size: size.r, color: color);
  }

  static EdgeInsets edgeInsetsAll(double value) {
    return EdgeInsets.all(value).r;
  }

  static EdgeInsets edgeInsetsSymmetric({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical).r;
  }

  static EdgeInsets edgeInsetsOnly({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) {
    return EdgeInsets.only(left: left, right: right, top: top, bottom: bottom).r;
  }

  // loaders and close loaders ----

  static Future<void> loaderDialog(BuildContext context, {String? message, bool barrierDismissible = false}) {
    _isDialogOpen = true;
    Widget loadingWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[loaderWidget(), message != null ? Text(message) : Container()],
    );
    return customDialog(context, loadingWidget, barrierDismissible: barrierDismissible);
  }

  static Widget loaderWidget({double size = 60}) {
    return SpinKitSpinningLines(
      size: size.r,
      color: AppColors.kPrimary,
      // duration: Duration(seconds: 3),
    );
  }

  static void closeLoaderDialog(BuildContext context) {
    if (_isDialogOpen) {
      Navigator.of(context).pop();
      _isDialogOpen = false;
    }
  }

  // loaders and close loaders end ----

  // toast ----
  static void toast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: AppColors.kBlackColor,
        textColor: AppColors.kWhiteColor,
        fontSize: 14.0.sp);
  }
  // toast end ----

  // dialogs ----
  static Future<dynamic> customDialog(BuildContext context, Widget child, {bool barrierDismissible = false}) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (ctx) {
          return child;
        });
  }
  // dialogs end ----


}
