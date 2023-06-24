import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/services_controller.dart';
import 'package:imei/widgets/app_widgets.dart';

import '../controllers/common_controller.dart';
import '../utils/images_path.dart';
import '../widgets/common_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final tag = 'SplashScreen ';
  final CommonController controller = Get.find<CommonController>();

  @override
  void initState() {
    super.initState();
    controller.startSplashScreenTimer();

  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: _buildSplashLogo(),
    );
  }

  Center _buildSplashLogo() {
    return Center(
      child: AppWidgets.image(
        ImagesPath.appIcon.toString(),
        width: 230.w,
        fit: BoxFit.contain,
      ),
    );
  }
}
