import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/signup_screen.dart';
import 'package:imei/utils/helper.dart';
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
  final TextEditingController _newPasswordTextEditingController = TextEditingController();
  final TextEditingController _ConfirmPasswordTextEditingController = TextEditingController();

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
                        if(_emailTextEditingController.text==null||_emailTextEditingController.text==""){
                          showToast("Please fill the field");
                        }else if(controller.loginCheckBoxValue.value==false){
                          showToast("please fill the checkbox");

                        }
                        else{
                          CommonController commonController = Get.find<CommonController>();
                          bool result = await commonController.checkUserExists(_emailTextEditingController.text);
                          if(result==true){
                            showDialog(context: context, builder: (context) {
                              return UpdatePasswordWidget(newPasswordTextEditingController: _newPasswordTextEditingController, ConfirmPasswordTextEditingController: _ConfirmPasswordTextEditingController, commonController: commonController, emailTextEditingController: _emailTextEditingController);
                            },);
                          }else{
                            showToast("User don't exists");
                          }

                        }

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

class UpdatePasswordWidget extends StatelessWidget {
  const UpdatePasswordWidget({
    super.key,
    required TextEditingController newPasswordTextEditingController,
    required TextEditingController ConfirmPasswordTextEditingController,
    required this.commonController,
    required TextEditingController emailTextEditingController,
  }) : _newPasswordTextEditingController = newPasswordTextEditingController, _ConfirmPasswordTextEditingController = ConfirmPasswordTextEditingController, _emailTextEditingController = emailTextEditingController;

  final TextEditingController _newPasswordTextEditingController;
  final TextEditingController _ConfirmPasswordTextEditingController;
  final CommonController commonController;
  final TextEditingController _emailTextEditingController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: AppColors.kPrimary,width: 2)),
      title: Text("Please enter new Password"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment:Alignment.centerLeft,
              child: Text("Password")).marginOnly(left: 5,bottom: 5),
          CustomTextFieldWithRectBorder(
            // readOnly: true,
            filled: true,
            controller: _newPasswordTextEditingController,
            filledColor: AppColors.kWhiteColor,
            hintText: "New Password",

          ),
          SizedBox(height: 15,),
          const Align(
              alignment:Alignment.centerLeft,
              child: Text("Confirm Password")).marginOnly(left: 5,bottom: 5),
          CustomTextFieldWithRectBorder(
            // readOnly: true,
            filled: true,
            controller: _ConfirmPasswordTextEditingController,
            filledColor: AppColors.kWhiteColor,
            hintText: "Confirm Password",
          ),
          SizedBox(height: 15,),
          CustomButton(
            buttonHeight: 50.h,
            buttonWidth: 360.w,
            buttonText: "Password Reset",
            buttonColor: AppColors.kPrimary,
            buttonTextStyle: AppTextStyles.black18W600TextStyle,
            buttonOnPressed: () async {
              if(_newPasswordTextEditingController.text==null||_newPasswordTextEditingController.text==""){
                showToast("please enter your new password");
              }else if(_newPasswordTextEditingController.text!=_ConfirmPasswordTextEditingController.text){
                showToast("Passwords doesn't match");
              }else{

               bool result = await commonController.updatePassword(_emailTextEditingController.text,_newPasswordTextEditingController.text);

               if(result==true){
                 Get.back();
                 Get.back();
               }else{
                 // Get.back();
               }

              }

            },
          ),

        ],),
    );
  }
}
