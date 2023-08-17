import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/login_screen.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';
import 'forget_password.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final tag = 'SignUpScreen ';
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        appBarTitle: 'SIGN UP',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin: AppWidgets.edgeInsetsSymmetric(horizontal: 40),
                child: Column(
                  children: [
                    AppWidgets.spacingHeight(80),
                    CustomTextFieldWithRectBorder(
                      filled: true,
                      controller: _userNameTextEditingController,
                      filledColor: AppColors.kWhiteColor,
                      // onChanged: (value) {
                      //
                      // },
                      hintText: "Enter your Username",
                    ),
                    AppWidgets.spacingHeight(10),
                    CustomTextFieldWithRectBorder(
                      filled: true,
                      controller: _emailTextEditingController,
                      filledColor: AppColors.kWhiteColor,
                      textInputType: TextInputType.emailAddress,
                      hintText: "Enter your Email",
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
                        Obx(() => Checkbox(
                            value: controller.isSignUpCheckBoxValue.value,
                            activeColor: AppColors.kPrimary,
                            onChanged: (bool? newValue) {
                              controller.isSignUpCheckBoxValue.value =
                                  newValue!;
                            })),
                        AppWidgets.text(
                          'Check me out',
                          style: AppTextStyles.black12TextStyle,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(ForgetScreen());
                          },
                          child: AppWidgets.text(
                            'Forget Password?',
                            style: AppTextStyles.black12TextStyle,
                          ),
                        ),
                      ],
                    ),
                    AppWidgets.spacingHeight(10),
                    CustomButton(
                      buttonHeight: 50.h,
                      buttonWidth: 360.w,
                      buttonText: "Sign Up",
                      buttonColor: AppColors.kPrimary,
                      buttonTextStyle: AppTextStyles.black18W600TextStyle,
                      buttonOnPressed: () async {
                        if (_userNameTextEditingController.text.length < 3) {
                          showToast("enter user-name mini 3 charter");
                          return;
                        }
                        if (_passwordTextEditingController.text.length < 6) {
                          showToast("enter password mini 6 charter");
                          return;
                        }

                        if (!GetUtils.isEmail(
                            _emailTextEditingController.text)) {
                          showToast("enter valid email");
                          return;
                        }
                        if (controller.isSignUpCheckBoxValue.value == false) {
                          showToast("please fill the checkbox");
                          return;
                        } else {
                          await controller.signUpUser(
                            email: _emailTextEditingController.text.trim(),
                            userName:
                                _userNameTextEditingController.text.trim(),
                            password:
                                _passwordTextEditingController.text.trim(),
                            phone:" ",
                          );
                        }
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
                      text: 'Already have an account?',
                      style: AppTextStyles.black14TextStyle,
                    ),
                    TextSpan(
                      text: '     Sign In',
                      style: AppTextStyles.primary16W700TextStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(LoginScreen());
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
