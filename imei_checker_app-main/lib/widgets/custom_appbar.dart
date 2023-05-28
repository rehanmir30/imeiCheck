import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';
import '../utils/images_path.dart';

class AppBarRoundedCorner extends StatelessWidget implements PreferredSizeWidget {
  AppBarRoundedCorner(
      {Key? key,
      this.leading,
      this.title,
      this.showTitle = false,
      this.actions,
      this.scaffoldKey,
      this.icon,
      this.onActionPressed,
      this.textController,
      this.isBackButton = true,
      this.isCrossButton = false,
      this.submitButtonText,
      this.automaticallyImplyLeading = true,
      this.isSubmitDisable = true,
      this.isBottomLine = true,
      this.isBackGroundColor = false,
      this.onSearchChanged})
      : super(key: key);

  final List<Widget>? actions;
  final Size appBarHeight = Size.fromHeight(75.0.h);
  final int? icon;
  final bool showTitle;
  final bool isBackButton;
  final bool automaticallyImplyLeading;
  final bool isBottomLine;
  final bool? isCrossButton;
  final bool? isSubmitDisable;
  final Widget? leading;
  final Function? onActionPressed;

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? submitButtonText;
  final TextEditingController? textController;
  final Widget? title;
  final bool? isBackGroundColor;
  final ValueChanged<String>? onSearchChanged;

  @override
  Size get preferredSize => appBarHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: isBackGroundColor == false
          ? AppColors.kPrimary
          : AppColors.kTransparentColor,
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ).r,
      ),
      leading:
          // !isBackButton
          isBackButton
              ? leading
              : Padding(
                  padding: const EdgeInsets.all(12.0).w,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 2.0,
                    shape: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10).r,
                      child: Center(
                        child: Icon(
                          Platform.isIOS ? Icons.arrow_back : Icons.arrow_back,
                          color: AppColors.kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
      title: showTitle
          ? Center(
              child: Image.asset(
                ImagesPath.appIcon.toString(),
                height: 80.h,
                width: 200.w,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20.0).r,
              child: title,
            ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(),
      ),
    );
  }
}
