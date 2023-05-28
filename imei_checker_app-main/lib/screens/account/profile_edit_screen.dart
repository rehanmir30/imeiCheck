
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/utils/helper.dart';
import 'package:imei/widgets/common_scaffold.dart';
import '../../controllers/authController.dart';
import '../../controllers/common_controller.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/colors.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({Key? key, }) : super(key: key);

  final tag = 'ProfileEditScreen ';

  AuthController authController=Get.find<AuthController>();

  final CommonController controller = Get.find<CommonController>();



  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController(text: authController.userModel!.userName);
     TextEditingController NameController = TextEditingController(text: authController.userModel!.name);
     TextEditingController emailController = TextEditingController(text: authController.userModel!.email);
     TextEditingController phoneController = TextEditingController(text: authController.userModel!.phone);
     TextEditingController passwordController = TextEditingController();
     TextEditingController confirmPasswordController = TextEditingController();
    return CommonScaffold(
        appBarTitle: 'Edit Profile',
        onBackTap: (){
          Navigator.pop(context);
        },
        body:  Container(
          margin: AppWidgets.edgeInsetsSymmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppWidgets.spacingHeight(50),
                CustomTextFieldWithRectBorder(
                   readOnly: true,
                  filled: true,
                  controller: userNameController,
                  filledColor: AppColors.kWhiteColor,
                  hintText: "Username",
                ),
                AppWidgets.spacingHeight(10),
                CustomTextFieldWithRectBorder(
                  filled: true,
                  controller: NameController,
                  filledColor: AppColors.kWhiteColor,
                  hintText: "Enter new name",
                ),
                AppWidgets.spacingHeight(10),
                CustomTextFieldWithRectBorder(
                  filled: true,
                  controller: emailController,
                  filledColor: AppColors.kWhiteColor,
                  hintText: "Enter new email",
                ),
                AppWidgets.spacingHeight(10),
                CustomTextFieldWithRectBorder(
                  filled: true,
                  controller: phoneController,
                  filledColor: AppColors.kWhiteColor,
                  hintText: "Enter new phone number",
                ),
                AppWidgets.spacingHeight(10),
                CustomTextFieldWithRectBorder(
                  filled: true,
                  obscureText: true,
                  controller: passwordController,
                  filledColor: AppColors.kWhiteColor,
                  hintText: "Enter new password",
                ),
                AppWidgets.spacingHeight(10),
                CustomTextFieldWithRectBorder(
                  filled: true,
                  obscureText: true,
                  controller: confirmPasswordController,
                  filledColor: AppColors.kWhiteColor,
                  hintText: "Re-Enter new password",
                ),

                // Row(
                //   children: [
                //     Obx(() =>  Checkbox(
                //         value: controller.isEditProfileCheckBoxValue.value,
                //         activeColor: AppColors.kPrimary,
                //         onChanged:(bool? newValue){
                //           controller.isEditProfileCheckBoxValue.value = newValue! ;
                //         })),
                //     AppWidgets.text('Check me out',
                //       style: AppTextStyles.black12TextStyle,
                //     ),
                //
                //
                //   ],
                // ),
                AppWidgets.spacingHeight(10),
                CustomButton(
                  buttonHeight: 50.h,
                  buttonWidth: 360.w,
                  buttonText: "Update Profile",
                  buttonColor: AppColors.kPrimary,
                  buttonTextStyle: AppTextStyles.black18W600TextStyle,
                  buttonOnPressed: () async {
                    // Get.to( const CustomBottomNavigation());


if((NameController.text==null||NameController.text=="")||(emailController.text==null||emailController.text=="")||(phoneController.text==null||phoneController.text=="")){
  showToast("Required fields cannot be empty");
  return;
}else if(passwordController!=null&&passwordController.text!=confirmPasswordController.text){
  showToast("Passwords don't match");
  return;
}else{

  await controller.profileUpdateApiCall(authController.userModel!.userName,NameController,emailController,phoneController,passwordController);

}
                  },
                ),




              ],
            ),
          ),
        ),);
  }
}
