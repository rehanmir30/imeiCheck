import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as strip;
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
import '../../model/InvoiceModel.dart';
import '../../model/StripePaymentModel.dart' as Modeling;
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
  CommonController commonController = Get.find<CommonController>();
Map<String,dynamic>? paymentIntents;

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

                          // await Future.delayed(Duration(seconds: 2),(){
                          //   Get.to(()=>TopUpHistoryScreen());
                          // });

                         }else if(widget.SelectedBankPaymentMethod=="Stripe"){

                           await makePayment(_enterAmountTextEditingController.text);
                         }
                       },
                     ),
                   ],
                 ),
               ),


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


  // _topUpCard() {
  //   return AppWidgets.sizedBoxWidget(
  //     height: 60.h,
  //     width: 320.w,
  //     child: Card(
  //       elevation: 3,
  //       shape: RoundedRectangleBorder(
  //         side:  const BorderSide(
  //           color: AppColors.kPrimary,
  //         ),
  //         borderRadius: BorderRadius.circular(40.0).r,
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Container(
  //             width: 150.w,
  //             decoration:  BoxDecoration(
  //               color: AppColors.kGreenColor,
  //               borderRadius: const BorderRadius.only(
  //                 topRight: Radius.circular(40),
  //                 bottomRight: Radius.circular(40),
  //               ).r,
  //             ),
  //             child: Center(
  //               child: AppWidgets.text('\$ TOP UP',
  //                   style: AppTextStyles.white18W600TextStyle
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> makePayment(amount) async {
    try {

      //STEP 1: Create Payment Intent
      print("Function Called 1");
      paymentIntents = await createPaymentIntent(amount, 'USD');
      print("Function Called 2");

      //STEP 2: Initialize Payment Sheet
      await strip.Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: strip.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntents!['client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              googlePay: strip.PaymentSheetGooglePay(currencyCode: 'PK',merchantCountryCode: 'US',),
              setupIntentClientSecret: paymentIntents!['client_secret'],
              appearance: strip.PaymentSheetAppearance(shapes: strip.PaymentSheetShape(borderRadius: 10)),
              merchantDisplayName: authController.userModel!.userName.toString()))
          .then((value) {
        // Modeling.StripePayementModel  model  =  Modeling.StripePayementModel.fromJson(paymentIntents!);
        //    print("DATA: "+model.status.toString());
      });

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
      //STEP 4: Fetch Data




    } catch (err) {
      throw Exception(err);
    }
  }

  calculateAmount(String amount){
    final price = int.parse(amount)*100;
    return price;
  }
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount).toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${commonController.bankKeyModel!.stripeSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      showToast("You can't transfer amount in cents");
      throw Exception(err.toString());
    }
  }

  displayPaymentSheet() async {
    print("Function Called 3");
    try {
      await strip.Stripe.instance.presentPaymentSheet().then((value) async {
        Modeling.StripePayementModel  model  =  Modeling.StripePayementModel.fromJson(paymentIntents!);
        BankTransferController bankTransferController = Get.find<BankTransferController>();
        CommonController commonController = Get.find<CommonController>();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.transparent,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Payment Successful!"),
                ],
              ),
            ));

        await bankTransferController.setWallet(model.amount.toString());
         await commonController.InvoicePostByBank( model.clientSecret,model.id,"Stripe",authController.userModel?.email,_enterAmountTextEditingController.text);
         closeLoadingDialog();
         Get.back();
         Get.to(()=>TopUpHistoryScreen());

        paymentIntents = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on strip.StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }
}
