import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/forget_password.dart';
import 'package:imei/screens/auth/signup_screen.dart';
import 'package:imei/utils/images_path.dart';
import 'package:imei/widgets/common_scaffold.dart';
import 'package:imei/widgets/custom_buttom_navigation.dart';

import '../../controllers/common_controller.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  final tag = 'LoginScreen ';
  final CommonController controller = Get.find<CommonController>();
   final TextEditingController _userNameTextEditingController = TextEditingController();
   final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        appBarTitle: 'SIGN IN',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Expanded(
              flex: 10,
              child: Container(
                margin: AppWidgets.edgeInsetsSymmetric(horizontal: 40),
                child: Column(
                  children: [
                    AppWidgets.spacingHeight(80),
                    CustomTextFieldWithRectBorder(
                      // readOnly: true,
                      filled: true,
                      controller: _userNameTextEditingController,
                      filledColor: AppColors.kWhiteColor,
                      hintText: "Enter your Username",
                    ),
                    AppWidgets.spacingHeight(10),
                    CustomTextFieldWithRectBorder(
                      filled: true,
                      controller: _passwordTextEditingController,
                      obscureText: true,
                      filledColor: AppColors.kWhiteColor,
                      hintText: "Enter your Password",

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
                        const Spacer(),
                        GestureDetector(
                          onTap: (){
                            Get.to(ForgetScreen());
                          },
                          child: AppWidgets.text('Forget Password?',
                            style: AppTextStyles.black12TextStyle,
                          ),
                        ),

                      ],
                    ),
                    AppWidgets.spacingHeight(10),
                    CustomButton(
                      buttonHeight: 50.h,
                      buttonWidth: 360.w,
                      buttonText: "Sign In",
                      buttonColor: AppColors.kPrimary,
                      buttonTextStyle: AppTextStyles.black18W600TextStyle,
                      buttonOnPressed: () async {

                        if(_userNameTextEditingController==null||_userNameTextEditingController.text.isEmpty){
                          showToast("Username is required");
                          return;
                        }else if(_passwordTextEditingController==null||_passwordTextEditingController.text.isEmpty){
                          showToast("Password is required");
                          return;
                        }else  if(controller.loginCheckBoxValue.value==null||controller.loginCheckBoxValue.value==false){
                          showToast("Please fill the checkbox");
                          return;
                        }else{
                          await controller.signInUser(
                        userName:
                        _userNameTextEditingController.text.trim(),
                        password:
                        _passwordTextEditingController.text.trim(),
                        );
                        }
                        //Get.to( const CustomBottomNavigation());

                      },
                    ),




                  ],
                ),
              ),
            ),

            Expanded(
              child: RichText(
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: AppTextStyles.black14TextStyle,
                    ),
                    TextSpan(
                      text: '     Sign Up',
                      style: AppTextStyles.primary16W700TextStyle,
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Get.to( SignUpScreen());
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
