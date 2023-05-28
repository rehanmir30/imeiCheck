import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/model/InvoiceModel.dart';
import 'package:imei/screens/result/result_details_screen.dart';

import '../utils/app_text_styles.dart';
import '../utils/colors.dart';
import '../utils/images_path.dart';
import 'InvoicePopup.dart';
import 'app_widgets.dart';

class ResultHistoryWidget extends StatelessWidget {
  InvoiceModel invoiceModel;
   ResultHistoryWidget({Key? key,required this.invoiceModel, required this.status, required this.titleId, this.amountText, this.amountTextShow = false, this.statusTextStyle}) : super(key: key);
  final String? status, titleId, amountText;
  final TextStyle? statusTextStyle;
  final bool? amountTextShow;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppWidgets.sizedBoxWidget(
          height: 50,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              side:  const BorderSide(
                color: AppColors.kPrimary,
              ),
              borderRadius: BorderRadius.circular(20.0).r,
            ),
            child: InkWell(

              onTap: ()async{
                // Get.to(ResultDetailsScreen());

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InvoicePopup(invoiceModel: invoiceModel,);
                    },
                  );

              },
              child: Container(
                margin: AppWidgets.edgeInsetsSymmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    AppWidgets.sizedBoxWidget(
                      width: 180.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          AppWidgets.text(
                            status.toString(),
                            style:  (status=="Paid")?AppTextStyles.green12TextStyle:AppTextStyles.red12TextStyle,
                          ),
                          AppWidgets.text(
                            titleId.toString(),
                            style: AppTextStyles.black12TextStyle,
                          ),
                        ],
                      ),
                    ),

                    AppWidgets.sizedBoxWidget(
                      width: 90,
                      child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,

                       children: [
                         amountTextShow == true ?
                         AppWidgets.text(
                           amountText.toString(),
                           style: AppTextStyles.pink14BoldTextStyle,
                         ) : Container(),

                         AppWidgets.image(
                           ImagesPath.documentOrangePNG,
                           height: 20.h,
                           width: 20.w,
                         ),
                       ],
                   ),
                    ),


                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
