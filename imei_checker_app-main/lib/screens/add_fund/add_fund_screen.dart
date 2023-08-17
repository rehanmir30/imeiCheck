
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/screens/add_fund/top_up_history_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/constants.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';

import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';
import 'add_fund_enter_amount.dart';

class AddFundScreen extends StatelessWidget {
  AddFundScreen({Key? key}) : super(key: key);
  final tag = 'AddFundScreen ';
  // final CommonController controller = Get.find<CommonController>();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'ADD FUND',
      body: Container(
        margin: AppWidgets.edgeInsetsSymmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            AppWidgets.spacingHeight(50),

            // _topUpCard(imagePath: ImagesPath.bankIconPNG,paymentMethod:"Direct Transfer"),
            _topUpCard(imagePath: ImagesPath.visaIconPNG ,paymentMethod:"Stripe"),
            _topUpCard(imagePath: ImagesPath.paypalIconPNG ,paymentMethod:"Paypal"),
            // _topUpCard(imagePath: ImagesPath.usdtIconPNG ,paymentMethod:"USDT"),

            AppWidgets.spacingHeight(30),
            CustomButton(
              buttonHeight: 50.h,
              buttonWidth: 300.w,
              buttonText: "VIEW TOP UP HISTORY",
              buttonColor: AppColors.kPrimary,
              buttonTextStyle: AppTextStyles.black18W600TextStyle,
              buttonOnPressed: () async {
                Get.to(TopUpHistoryScreen());
              },
            ),

          ],
        )
      ),
    );
  }

  _topUpCard({String? imagePath ,String? paymentMethod}) {
    return Container(
      height: 60.h,
      width: 310.w,
      margin: AppWidgets.edgeInsetsSymmetric(vertical: 6.0,),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side:  const BorderSide(
            color: AppColors.kPrimary,
          ),
          borderRadius: BorderRadius.circular(40.0).r,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppWidgets.image(
              imagePath.toString(),
              height: 40,
              width: 50,
            ),
            AppWidgets.spacingWidth(50),
            InkWell(
              onTap: () {
                Get.to(AddFundEnterAmountScreen(imagePath.toString(),paymentMethod));
              },
              child: Container(
                height: 60.h,
                width: 150.w,
                decoration:  BoxDecoration(
                  color: AppColors.kGreenColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ).r,
                ),
                child: Center(
                  child: AppWidgets.text('\$ TOP UP',
                  style: AppTextStyles.white18W600TextStyle
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
