import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imei/controllers/authController.dart';


class PaypalPayment extends StatefulWidget {
  var enteredAmount;
   PaypalPayment(this.enteredAmount,{Key? key}) : super(key: key);

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
          print("onSuccess: $params");
        },
        onError: (error) {
          print("onError: $error");
        },
        onCancel: (params) {
          print('cancelled: $params');
        });
  }
}
