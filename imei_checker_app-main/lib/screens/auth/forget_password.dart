import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/signup_screen.dart';
import 'package:imei/utils/images_path.dart';
import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/colors.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';

class ForgetScreen extends StatelessWidget {
  ForgetScreen({Key? key}) : super(key: key);
  final tag = 'ForgetScreen ';
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController _emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        appBarTitle: 'FORGET PASSWORD',

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children:  [

            Expanded(
              flex: 10,
              child: Container(
                margin: AppWidgets.edgeInsetsSymmetric(horizontal: 40),
                child: Column(
                  children: [
                    AppWidgets.spacingHeight(130),
                    CustomTextFieldWithRectBorder(
                      // readOnly: true,
                      filled: true,
                      controller: _emailTextEditingController,
                      filledColor: AppColors.kWhiteColor,
                      hintText: "Enter your Username",

                    ),

                    Row(
                      children: [
                        Obx(() =>  Checkbox(
                            value: controller.loginCheckBoxValue.value,
                            activeColor: AppColors.kPrimary,
                            onChanged:(bool? newValue){
                              controller.loginCheckBoxValue.value = newValue! ;
                            })),

                        AppWidgets.text('Check me out',
                          style: AppTextStyles.black12TextStyle,
                        ),
                      ],
                    ),
                    AppWidgets.spacingHeight(10),
                    CustomButton(
                      buttonHeight: 50.h,
                      buttonWidth: 360.w,
                      buttonText: "Password Reset",
                      buttonColor: AppColors.kPrimary,
                      buttonTextStyle: AppTextStyles.black18W600TextStyle,
                      buttonOnPressed: () async {

                      },
                    ),




                  ],
                ),
              ),
            ),



          ],
        ));
  }
}
