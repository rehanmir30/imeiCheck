
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/BankTransferController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/screens/add_fund/top_up_history_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/constants.dart';
import 'package:imei/utils/helper.dart';
import 'package:imei/utils/images_path.dart';
import 'package:imei/widgets/TransactionPopup.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../Payment/PaypalPayment.dart';
import '../../controllers/common_controller.dart';

import '../../model/InvoiceModel.dart';
import '../../widgets/InvoicePopup.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_fields.dart';

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

                          await Get.to(()=>UsePaypal(
                               sandboxMode: true,
                               clientId:
                               "AQ1uLtsTHhGFqwNbwiWQt8oxNAoJtYwJ90_TvuYOixvOIfbFXd3Y9Cx5O6cJhPq-8ljtf9yN3AB5voMx",
                               secretKey:
                               "EKm3aFddHE2wwdgnpiRzJ6W_On-99t5UfqdnggfH-tLst4atGqJoIK1u-CEyCIuNKwx8MDMf9Eo2sfFv",
                               returnURL: "https://samplesite.com/return",
                               cancelURL: "https://samplesite.com/cancel",
                               transactions: [
                                 {
                                   "amount": {
                                     "total": '${_enterAmountTextEditingController.text}',
                                     "currency": "USD",
                                     "details": {
                                       "subtotal": '${_enterAmountTextEditingController.text}',
                                       "shipping": '0',
                                       "shipping_discount": 0
                                     }
                                   },
                                   "description":
                                   "${authController.userModel?.name} has purchased a load of ${_enterAmountTextEditingController.text}",
                                   // "payment_options": {
                                   //   "allowed_payment_method":
                                   //       "INSTANT_FUNDING_SOURCE"
                                   // },
                                   "item_list": {
                                     "items": [
                                       {
                                         "name": "${authController.userModel?.name}",
                                         "quantity": 1,
                                         "price": '${_enterAmountTextEditingController.text}',
                                         "currency": "USD"
                                       }
                                     ],
                                   }
                                 }
                               ],
                               note: "Contact us for any questions on your order.",
                               onSuccess: (Map params) async {
                                 var rnd = new Random();
                                 var next = rnd.nextDouble() * 1000;
                                 while (next < 1000) {
                                   next *= 10;
                                 }

                                 BankTransferController bankTransferController = Get.find<BankTransferController>();
                                 CommonController commonController = Get.find<CommonController>();
                                 print("onSuccess: $params");
                                 var payerId = params['payerID'];
                                 var paymentId = params['paymentId'];
                                 var status = params['status'];
                                 var paymentMethod = params['data']['payer']['payment_method'];
                                 var payerEmail = params['data']['payer']['payer_info']['email'];
                                 var amount = _enterAmountTextEditingController.text.toString();
                                 print("payerID: ${payerId}");
                                 print("status: ${status}");
                                 print("paymentId: ${paymentId}");
                                 print("paymentMethod: ${paymentMethod}");
                                 print("payerEmail: ${payerEmail}");
                                 print("amount: ${amount}");
                                 showToast("TransactionSuccessful");
                                 await bankTransferController.setWallet(_enterAmountTextEditingController.text.toString());
                                 InvoiceModel invoice = await commonController.InvoicePostByBank( payerId,paymentId,paymentMethod,payerEmail,amount);

                                 Get.back();
                                 // Get.back(result: invoiceModel);
                                 return invoice;
                               },
                               onError: (error) {
                                 print("onError: $error");
                                 showToast(error.toString());
                                 return ;
                               },
                               onCancel: (params) {
                                 print('cancelled: $params');
                                 return;
                               })
                          );


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
