import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/auth/login_screen.dart';
import 'package:imei/screens/imei/tabs/imei_bulk_tab.dart';
import 'package:imei/screens/imei/tabs/imei_single_tab.dart';
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

class IMEICheckScreen extends StatelessWidget {
  IMEICheckScreen({Key? key}) : super(key: key);
  final tag = 'IMEICheckScreen ';
  final CommonController controller = Get.find<CommonController>();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'IMEI CHECK',
      body: Container(
        margin: AppWidgets.edgeInsetsSymmetric(horizontal: 16),
        child: Column(
          children: [
            AppWidgets.spacingHeight(30),
            Container(
              margin: AppWidgets.edgeInsetsSymmetric(horizontal: 35),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  _sizeBoxCardDesign(
                    buttonText: 'Single',
                    buttonColor: controller.imeiSelectTabValue.value  ? AppColors.kWhiteColor : AppColors.kPrimary,
                    buttonTextStyle: controller.imeiSelectTabValue.value  ? AppTextStyles.primary18W600TextStyle : AppTextStyles.white18W600TextStyle,
                  ),
                  _sizeBoxCardDesign(
                    buttonText: 'Bulk',
                    buttonColor: controller.imeiSelectTabValue.value  ? AppColors.kPrimary : AppColors.kWhiteColor,
                    buttonTextStyle: controller.imeiSelectTabValue.value  ? AppTextStyles.white18W600TextStyle : AppTextStyles.primary18W600TextStyle,

                  ),
                ],
              ),),
            ),
            AppWidgets.spacingHeight(10),


            Obx(() {
              if (controller.imeiSelectTabValue.value) {
                return  Expanded(
                  child: BulkTabWidget()
                );
              }

              return Expanded(
                child: SingleTabWidget()
              );
            }),







          ],
        ),
      ),


    );




  }

   _sizeBoxCardDesign({String? buttonText, Color? buttonColor, TextStyle? buttonTextStyle }) {
    return CustomButton(
      buttonHeight: 40.h,
      buttonWidth: 110.w,
      buttonText: buttonText.toString(),
      buttonColor: buttonColor,
      buttonTextStyle: buttonTextStyle,
      buttonOnPressed: () async {
        if (controller.imeiSelectTabValue.value == false) {
          controller.imeiSelectTabValue.value  = true;
        } else {
          controller.imeiSelectTabValue.value  = false;
        }

      },
    );
  }

}
