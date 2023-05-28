import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:imei/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';


void showLoadingDialog(
    {Color? loaderColor, double? size, bool dismissible = false}) async {
  await Get.dialog(kLoadingWidget(loaderColor: loaderColor, size: size),
      barrierColor: AppColors.kTransparentColor,
      barrierDismissible: dismissible);
}

void closeLoadingDialog() {
  if (Get.isDialogOpen != null && Get.isDialogOpen!) {
    Get.back();
  }
}

Widget kLoadingWidget({Color? loaderColor, double? size}) => Center(
      child: SpinKitFadingCube(
        color: loaderColor ?? AppColors.kPrimary,
        size: size ?? 30.0,
      ),
    );

showToast(String message) {

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.lightGrey,
      textColor: AppColors.kWhiteColor,
      fontSize: 16);
}

convertStringToInt(String data) {
  if (data.isEmpty) {
    return 0;
  }
  try {
    int res = int.parse(data);
    return res;
  } catch (e) {
    showToast("conversionFailed".tr);
    return 0;
  }
}

showAlert(
    {required DialogType dialogType,
    required String title,
    String? description,
    String? btnCancelText,
    String? btnOkText,
    Color? btnOkColor,
    bool reverseBtnOrder = false,
    Color? btnCancelColor,
    VoidCallback? onCancelPress,
    VoidCallback? onOkPress,
    Function(DismissType dismissType)? onDismissCallBack,
    bool autoDismiss = true,
    bool dismissOnTouchOutside = true,
    bool dismissOnBackKeyPress = true}) {
  AwesomeDialog(
    context: Get.context as BuildContext,
    dismissOnTouchOutside: dismissOnTouchOutside,
    dialogType: dialogType,
    width: 400,
    reverseBtnOrder: reverseBtnOrder,
    animType: AnimType.bottomSlide,
    title: title,
    btnOkColor: btnOkColor,
    btnCancelColor: btnCancelColor,
    onDismissCallback: onDismissCallBack,
    autoDismiss: autoDismiss,
    desc: description ?? "",
    btnCancelText: btnCancelText ?? "dismiss".tr,
    btnOkText: btnOkText,
    btnCancelOnPress: onCancelPress ?? () {},
    btnOkOnPress: onOkPress,
    dismissOnBackKeyPress: dismissOnBackKeyPress,
  ).show();
}

openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    showAlert(
        dialogType: DialogType.error,
        title: "launchUrlFailed".tr,
        description: "${"launchUrlFailed".tr} $url");
  }
}
