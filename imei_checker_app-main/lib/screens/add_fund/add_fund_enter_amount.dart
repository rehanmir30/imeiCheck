import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/BankTransferController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/screens/add_fund/top_up_history_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/helper.dart';
import 'package:imei/widgets/common_scaffold.dart';
import '../../Payment/PaypalPayment.dart';
import '../../controllers/common_controller.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';
import 'package:http/http.dart' as http;

class AddFundEnterAmountScreen extends StatefulWidget {
  var SelectedBankImage;
  var SelectedBankPaymentMethod;
   AddFundEnterAmountScreen(this.SelectedBankImage,this.SelectedBankPaymentMethod,{Key? key}) : super(key: key);

  @override
  State<AddFundEnterAmountScreen> createState() => _AddFundEnterAmountScreenState();
}

class _AddFundEnterAmountScreenState extends State<AddFundEnterAmountScreen> {
  final tag = 'AddFundEnterAmountScreen ';

  // final CommonController controller = Get.find<CommonController>();
  final TextEditingController _enterAmountTextEditingController = TextEditingController();

  AuthController authController = Get.find<AuthController>();
  Map<String,dynamic>? makePayment;

  @override
  Widget build(BuildContext contexts) {
    return CommonScaffold(
      appBarTitle: 'ADD FUND',
      body: Container(
          margin: AppWidgets.edgeInsetsSymmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: [

          AppWidgets.sizedBoxWidget(
          height: 280.h,
          child: Card(
            elevation: 3,
            shape: const Border(
                right: BorderSide( color: AppColors.kPrimary, width: 1,),
              left: BorderSide( color: AppColors.kPrimary, width: 1),
              top: BorderSide( color: AppColors.kPrimary, width: 1),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

               Container(
                 margin: AppWidgets.edgeInsetsSymmetric(horizontal: 12, ),

                 child: Column(
                   children: [
                     AppWidgets.image(
                       widget.SelectedBankImage.toString(),
                       height: 80,
                     ),
                     AppWidgets.spacingHeight(35),

                     AppWidgets.sizedBoxWidget(
                       height: 35.h,
                       width: 300.w,
                       child: CustomTextFieldWithRectBorder(
                         filled: true,
                         controller: _enterAmountTextEditingController,
                         filledColor: AppColors.kWhiteColor,
                         hintText: "Enter Your Amount",
                         focusedBorderRadius: 18,
                         enabledBorderRadius: 18,
                       ),
                     ),
                     AppWidgets.spacingHeight(10),

                     CustomButton(
                       buttonHeight: 40.h,
                       buttonWidth: 300.w,
                       buttonText: "PAY NOW",
                       buttonColor: AppColors.kPrimary,
                       buttonTextStyle: AppTextStyles.black18W600TextStyle,
                       buttonOnPressed: () async {

                         if(widget.SelectedBankPaymentMethod=="Direct Transfer" || widget.SelectedBankPaymentMethod =="USDT"){
                           if(_enterAmountTextEditingController.text==null||_enterAmountTextEditingController.text==""){
                             showToast("Please enter the amount");
                             return;
                           }else{
                             CommonController commonController = Get.find<CommonController>();
                             BankTransferController bankTransferController = Get.find<BankTransferController>();
                             await commonController.InvoicePost(_enterAmountTextEditingController.text,widget.SelectedBankPaymentMethod,context);

                           }

                         }else if(widget.SelectedBankPaymentMethod=="Paypal"){
                           BankTransferController controller = Get.find<BankTransferController>();

                          await Get.to(()=>PaypalPayment(_enterAmountTextEditingController.text, contexts));

                         }else if(widget.SelectedBankPaymentMethod=="Stripe"){



                         }
                       },
                     ),
                   ],
                 ),
               ),

                // Container(
                //   transform: Matrix4.translationValues(0, 40.spMin, 0),
                //   child: _topUpCard(),
                // ),

              ],
            ),

          ),
          ),



              AppWidgets.spacingHeight(50),
              CustomButton(
                buttonHeight: 50.h,
                buttonWidth: 320.w,
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

createPayment(String amount, String curreny) async {
    try{
      Map<String,dynamic> body = {
        'amount': int.parse(amount.toString()),
        'currency':curreny,
        'payment_method_types[]':'card'
      };
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),

        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51ND5WZL4c8dEbwgLkVzsdkfc7foyMGsMShgUEDXTMni09t2ThclYbD03NJqe7AERJRO7cO3DWHTcf1qNDkNdpA91007dAdLXwf',
          'Content-Type':'application/x-www-form-urlencoded'
        });

      return jsonDecode(response.body.toString());

    }catch(e){
      print('exception'+e.toString());

    }

}

  _topUpCard() {
    return AppWidgets.sizedBoxWidget(
      height: 60.h,
      width: 320.w,
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
            Container(
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
          ],
        ),
      ),
    );
  }
}
