import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/login_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';

import '../utils/images_path.dart';
import '../widgets/app_widgets.dart';
import '../widgets/common_scaffold.dart';
import '../widgets/custom_button.dart';
import 'auth/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  final tag = 'WelcomeScreen ';

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyTopCarveLogoNotShow: true,
      body: Column(
        children: [
          Expanded(
              child: Center(
                child: AppWidgets.image(
                  ImagesPath.appIcon.toString(),
                  width: 230.w,
                ),
              )),
          Expanded(
            flex: 2,
            child: Container(
              width: 360.w,
              decoration: BoxDecoration(
                color: AppColors.kPrimary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ).r,
              ),
              child: Container(
                // color: Colors.white,
                margin: AppWidgets.edgeInsetsSymmetric(
                  vertical: 30,
                  horizontal: 30
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    AppWidgets.text('Welcome',
                      style: AppTextStyles.black30BoldTextStyle,
                    ),
                    AppWidgets.spacingHeight(4),
                    AppWidgets.text('We are an online provider of mobile device analytics services. We are best recognized for the innovations we create, our world-renowned technology and our industry-leading customer service! \n\nWe are based in London, UK. We launched in 2016 and have since become the fastest-growing analytics provider in the world, powering tens of millions of repairs and recycles.',
                      style: AppTextStyles.black15TextStyle,
                    ),
                    AppWidgets.spacingHeight(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          buttonHeight: 40.h,
                          buttonWidth: 120.w,
                          buttonText: "Sign In",
                          buttonColor: AppColors.kBlackColor,
                          borderRadius: BorderRadius.circular(15.0).r,
                          buttonTextStyle: AppTextStyles.white18W600TextStyle,
                          buttonOnPressed: () async {
                            Get.to( LoginScreen());
                          },
                        ),

                        CustomButton(
                          buttonHeight: 40.h,
                          buttonWidth: 120.w,
                          buttonText: "Sign Up",
                          buttonColor: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.circular(15.0).r,
                          buttonTextStyle: AppTextStyles.primary18W600TextStyle,
                          buttonOnPressed: () async {
                            Get.to( SignUpScreen());

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),


            ),
          ),
        ],
      ),
    );
  }


}
