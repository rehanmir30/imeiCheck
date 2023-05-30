import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imei/controllers/BankTransferController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/controllers/common_controller.dart';
import 'package:imei/model/InvoiceModel.dart';
import 'package:imei/utils/helper.dart';
import 'package:intl/intl.dart';

import '../screens/add_fund/top_up_history_screen.dart';
import '../widgets/TransactionPopup.dart';


class PaypalPayment extends StatefulWidget {
  var contexts;
  var enteredAmount;
   PaypalPayment(this.enteredAmount,contexts,{Key? key}) : super(key: key);

  @override
  State<PaypalPayment> createState() => _PaypalPaymentState();
}

class _PaypalPaymentState extends State<PaypalPayment> {
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return UsePaypal(
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
              "total": '${widget.enteredAmount}',
              "currency": "USD",
              "details": {
                "subtotal": '${widget.enteredAmount}',
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description":
            "${authController.userModel?.name} has purchased a load of ${widget.enteredAmount}",
            // "payment_options": {
            //   "allowed_payment_method":
            //       "INSTANT_FUNDING_SOURCE"
            // },
            "item_list": {
              "items": [
                {
                  "name": "${authController.userModel?.name}",
                  "quantity": 1,
                  "price": '${widget.enteredAmount}',
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
          var amount = widget.enteredAmount.toString();
          print("payerID: ${payerId}");
          print("status: ${status}");
          print("paymentId: ${paymentId}");
          print("paymentMethod: ${paymentMethod}");
          print("payerEmail: ${payerEmail}");
          print("amount: ${amount}");
          showToast("TransactionSuccessful");
          await bankTransferController.setWallet(widget.enteredAmount.toString());
          InvoiceModel invoice = await commonController.InvoicePostByBank( payerId,paymentId,paymentMethod,payerEmail,amount);

          Get.back();
          Get.to(()=>TopUpHistoryScreen());
          // Get.back(result: invoiceModel);
          return invoice;
         // Get.back(result: invoiceModel);
        },
        onError: (error) {
          print("onError: $error");
          showToast(error.toString());
        },
        onCancel: (params) {
          print('cancelled: $params');
          showToast(params.toString());
        });
  }
}
