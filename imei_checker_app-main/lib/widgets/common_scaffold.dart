import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imei/utils/images_path.dart';

import '../utils/app_text_styles.dart';
import '../utils/colors.dart';
import '../utils/logger.dart';
import 'app_widgets.dart';
import 'custom_appbar.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    Key? key,
    required this.body,
    this.appBarTitle,
    this.onBackTap,
    this.appBarActions,
    this.appBarLeading,
    this.appBarMaxLines,
    this.appBar,
    this.bodyTopCarveLogoNotShow = false,
    this.bodyBottomCarveLogoNotShow = false,
    this.drawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.automaticallyImplyLeading,
    this.appBarCenteredTitle,
    this.appBarBottom,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  final Widget body;
  final String? appBarTitle;
  final Function()? onBackTap;
  final List<Widget>? appBarActions;
  final Widget? drawer;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final int? appBarMaxLines;
  final bool? automaticallyImplyLeading;
  final bool? appBarCenteredTitle;
  final PreferredSizeWidget? appBarBottom;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? bodyTopCarveLogoNotShow, bodyBottomCarveLogoNotShow;
  /// you will not need to add back button in leading, it will be added automatically
  final Widget? appBarLeading;
  final AppBar? appBar;

  final String tag = "CommonScaffold";

  @override
  Widget build(BuildContext context) {
    Logger.info(tag, "Inside build");
    return
      SafeArea(
        child: Container(
          color: AppColors.kWhiteColor,
          child: Stack(
            children: [

              bodyTopCarveLogoNotShow == true ?
                 const SizedBox.shrink() :
              Align(
                alignment: Alignment.topRight,
                child:
                AppWidgets.imageSVG(
                  ImagesPath.bodyBottomLogo,
                  height: 130.h,
                  width: 60.w,
                  fit: BoxFit.contain,
                ),
              ),

              bodyBottomCarveLogoNotShow == true ?
              const SizedBox.shrink() :
              Align(
                alignment: Alignment.bottomLeft,
                child: AppWidgets.imageSVG(
                  ImagesPath.bodyTopLogo,
                  height: 100.h,
                  width: 60.w,
                  fit: BoxFit.contain,
                ),
              ),
              Scaffold(
                resizeToAvoidBottomInset: false,
                drawer: drawer,
                backgroundColor: backgroundColor ?? AppColors.kTransparentColor,
                bottomNavigationBar: bottomNavigationBar,
                appBar: appBar ?? (appBarTitle == null || appBarTitle == '' ? null : _buildAppBar(context)),
                body: body,
                floatingActionButton: floatingActionButton,
                floatingActionButtonLocation: floatingActionButtonLocation,
              ),



            ],
          ),
        ),
      );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    Logger.info(tag, "Inside _buildAppBar");
    return AppBarRoundedCorner(
      isBackButton: true,
      isBottomLine: true,
      showTitle: false,
      title: Text(
        appBarTitle!,
        style: AppTextStyles.black18W600TextStyle,
      ),
    );
  }
}
