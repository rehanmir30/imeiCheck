import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:imei/screens/add_fund/add_fund_enter_amount.dart';
import 'package:imei/screens/add_fund/add_fund_screen.dart';
import 'package:imei/screens/add_fund/top_up_history_screen.dart';
import 'package:imei/screens/imei/qr_scaner_screen.dart';
import 'package:imei/screens/splash_screens.dart';
import 'package:imei/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imei/utils/logger.dart';
import 'package:imei/widgets/custom_buttom_navigation.dart';
import 'controllers/binding/controller_binding.dart';
import 'screens/result/result_details_screen.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await GetStorage.init(Constants.keyDbName);
  runApp(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            title: AppConstant.appName,

            debugShowCheckedModeBanner: false,
            initialRoute: PageRoutes.splashPage,
            initialBinding: ControllersBinding(),
              home:  const SplashScreen(),

          );
        },
      ));
}




