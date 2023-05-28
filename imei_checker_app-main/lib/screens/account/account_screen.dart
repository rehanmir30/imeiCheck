import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/screens/account/profile_edit_screen.dart';
import 'package:imei/screens/account/profile_view_screen.dart';
import 'package:imei/screens/auth/login_screen.dart';
import 'package:imei/screens/imei/tabs/imei_bulk_tab.dart';
import 'package:imei/screens/imei/tabs/imei_single_tab.dart';
import 'package:imei/screens/welcome_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';

import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';
import '../result/result_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);
  final tag = 'AccountScreen ';
  final CommonController controller = Get.find<CommonController>();
AuthController authController=Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'MY ACCOUNT',
      body: Container(
        child: Center(
          child: Column(
            children: [
              AppWidgets.spacingHeight(30),
              CircleAvatar(
                radius: 60.r,
                child: ClipOval(
                  child: authController.userModel!.img==null||authController.userModel!.img==""?Image.network(
                    ImagesPath.profileNetWorkImage,
                  ):Image.network(
                    authController.userModel!.img,
                  ),
                ),
              ),
              AppWidgets.spacingHeight(30),


              AppWidgets.text(authController.userModel!.name,
              style: AppTextStyles.primary22BoldTextStyle
              ),
              AppWidgets.spacingHeight(20),

              _buttons(
                btnName: 'View Profile',
                btnOnPressed: ()async{
                  Get.to(ViewProfileScreen(
                  ));
                }
              ),
              _buttons(
                  btnName: 'Edit Profile',
                  btnOnPressed: ()async{
                    Get.to(ProfileEditScreen(

                    ));
                  }
              ),
              _buttons(
                  btnName: 'Log Out',
                  btnOnPressed: ()async{
                    Get.off(()=>WelcomeScreen());
                  }
              ),







            ],
          ),
        ),
      ),


    );




  }

  _buttons({String? btnName, VoidCallback? btnOnPressed}){
    return  Padding(
      padding: AppWidgets.edgeInsetsOnly(bottom: 10),
      child: CustomButton(
        buttonHeight: 45.h,
        buttonWidth: 310.w,
        buttonText: btnName.toString(),
        buttonColor: AppColors.kWhiteColor,
        buttonTextStyle: AppTextStyles.primary16W700TextStyle,
        buttonOnPressed: btnOnPressed,
      ),
    );
  }

}
