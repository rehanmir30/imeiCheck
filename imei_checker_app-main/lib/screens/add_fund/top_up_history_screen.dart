

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/InvoiceController.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';

import '../../widgets/InvoicePopup.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';

class TopUpHistoryScreen extends StatelessWidget {
  TopUpHistoryScreen({Key? key}) : super(key: key);
  final tag = 'TopUpHistoryScreen ';
  // final CommonController controller = Get.find<CommonController>();
  final TextEditingController _searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'TOP UP HISTORY',
      body: Container(
        margin: AppWidgets.edgeInsetsSymmetric(horizontal: 16),
        child: Column(
          children:  [
            AppWidgets.spacingHeight(15),
            AppWidgets.sizedBoxWidget(
              height: 40.h,
              child: CustomTextFieldWithRectBorder(
                filled: true,
                suffixIcon: const Icon(Icons.search, color: AppColors.kPrimary,size: 22,),
                controller: _searchTextEditingController,
                filledColor: AppColors.kWhiteColor,
                hintText: "Search",
                focusedBorderRadius: 18,
                enabledBorderRadius: 18,
              ),
            ),
            AppWidgets.spacingHeight(10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GetBuilder<InvoiceController>(builder: (controller) {
                  return ListView.builder(
                    shrinkWrap: true,
                      primary: false,
                      reverse: true,
                      itemCount: controller.invoiceList!.length,
                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                          onTap: (){
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return InvoicePopup();
                              //   },
                              // );
                          },
                          child: ResultHistoryWidget(status: controller.invoiceList![index].status.toString(), titleId: controller.invoiceList![index].paymentMethod.toString(),
                            statusTextStyle: AppTextStyles.green12TextStyle,
                                  amountTextShow: true,
                                  amountText: '\$${controller.invoiceList![index].totalAmount.toString()}', invoiceModel: controller.invoiceList![index],

                          ),
                        );

                      });

                },),
                // child: Column(
                //   children: [
                //
                //     ResultHistoryWidget(
                //       status: 'Paid',
                //       titleId: 'Paypal',
                //       statusTextStyle: AppTextStyles.green12TextStyle,
                //       amountTextShow: true,
                //       amountText: '\$ 20',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Failed',
                //       titleId: 'Credit Card',
                //       statusTextStyle: AppTextStyles.primary12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 15',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Rejected',
                //       titleId: 'USTD',
                //       statusTextStyle: AppTextStyles.red12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 30',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Unpaid',
                //       titleId: 'Bank Transfer',
                //       statusTextStyle: AppTextStyles.blue12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 20',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Paypal',
                //       titleId: 'Paid',
                //       statusTextStyle: AppTextStyles.green12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 50',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Paid',
                //       titleId: 'Paypal',
                //       statusTextStyle: AppTextStyles.green12TextStyle,
                //       amountTextShow: true,
                //       amountText: '\$ 20',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Failed',
                //       titleId: 'Credit Card',
                //       statusTextStyle: AppTextStyles.primary12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 15',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Rejected',
                //       titleId: 'USTD',
                //       statusTextStyle: AppTextStyles.red12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 30',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Unpaid',
                //       titleId: 'Bank Transfer',
                //       statusTextStyle: AppTextStyles.blue12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 20',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Paypal',
                //       titleId: 'Paid',
                //       statusTextStyle: AppTextStyles.green12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 50',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Paid',
                //       titleId: 'Paypal',
                //       statusTextStyle: AppTextStyles.green12TextStyle,
                //       amountTextShow: true,
                //       amountText: '\$ 20',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Failed',
                //       titleId: 'Credit Card',
                //       statusTextStyle: AppTextStyles.primary12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 15',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Rejected',
                //       titleId: 'USTD',
                //       statusTextStyle: AppTextStyles.red12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 30',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Unpaid',
                //       titleId: 'Bank Transfer',
                //       statusTextStyle: AppTextStyles.blue12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 20',
                //     ),
                //     ResultHistoryWidget(
                //       status: 'Paypal',
                //       titleId: 'Paid',
                //       statusTextStyle: AppTextStyles.green12TextStyle,
                //
                //       amountTextShow: true,
                //       amountText: '\$ 50',
                //     ),
                //   ],
                // ),
              ),
            ),






          ],
        ),
      ),


    );




  }


}
