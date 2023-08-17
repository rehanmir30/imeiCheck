import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/forget_password.dart';
import 'package:imei/screens/auth/signup_screen.dart';
import 'package:imei/utils/images_path.dart';
import 'package:imei/widgets/common_scaffold.dart';
import 'package:imei/widgets/custom_buttom_navigation.dart';

import '../../controllers/authController.dart';
import '../../controllers/common_controller.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/colors.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';

class ViewProfileScreen extends StatefulWidget {
  ViewProfileScreen({Key? key,}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final tag = 'ViewProfileScreen ';

  final CommonController controller = Get.find<CommonController>();

   TextEditingController _nameTextEditingController = TextEditingController();

   TextEditingController _emailTextEditingController = TextEditingController(text: 'sahbazjavad@gmail.com');

   TextEditingController _phoneTextEditingController = TextEditingController(text: '00000000000');

  AuthController authController=Get.find<AuthController>();


  @override
  void initState() {
    _nameTextEditingController=TextEditingController(text:authController.userModel!.userName);
    _emailTextEditingController=TextEditingController(text: authController.userModel!.email);
    _phoneTextEditingController=TextEditingController(text: authController.userModel!.phone);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        appBarTitle: 'View Profile',
        onBackTap: (){
          Navigator.pop(context);
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children:  [
            AppWidgets.spacingHeight(30),

            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kPrimary
              ),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60.r,
                  child: ClipOval(
                    child: authController.userModel!.img==null||authController.userModel!.img==""?Image.asset(
                      "assets/icons/appIcon.png",
                      height: 80,
                      width: 80,
                    ):Image.network(
                      authController.userModel!.img,
                    ),
                  ),
                ),
              ),
            ),

            AppWidgets.spacingHeight(20),

            Expanded(
              child: Container(
                margin: AppWidgets.edgeInsetsSymmetric(horizontal: 40),
                child: Column(
                  children: [
                    CustomTextFieldWithRectBorder(
                      readOnly: true,
                      filled: true,
                      controller: _nameTextEditingController,
                      filledColor: AppColors.kWhiteColor,

                    ),
                    AppWidgets.spacingHeight(10),
                    CustomTextFieldWithRectBorder(
                      readOnly: true,
                      filled: true,
                      controller: _emailTextEditingController,
                      filledColor: AppColors.kWhiteColor,


                    ),
                    AppWidgets.spacingHeight(10),
                    
                    AppWidgets.spacingHeight(10),
                    AppWidgets.spacingHeight(10),

                    InkWell(
                      onTap: (){

                        showDialog(context: context, builder: (context) {
                          return AlertDialog(

                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            title: Text('Delete Account'),
                            content: Container(
                              height: 100,
                              child: Column(
                                children: [
                                  Text('Are you sure you want to delete your account permanently'),
                                  Expanded(child: Container()),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      InkWell(
                                          onTap:(){
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel')),
                                      SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.kRedColor),
                                          onPressed: () async{
                                          CommonController commController = Get.find<CommonController>();

                                          await commController.deleteAccount(_nameTextEditingController.text);


                                      }, child: Text('Delete')),

                                  ],)
                                ],
                              ),
                            ),
                          );
                        },);

                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text('Delete Account',style: TextStyle(color: AppColors.kWhiteColor,fontSize: 18,fontWeight: FontWeight.bold),),
                      ),
                    ),




                  ],
                ),
              ),
            ),






          ],
        ));
  }
}
