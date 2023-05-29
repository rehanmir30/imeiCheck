import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/controllers/common_controller.dart';
import 'package:imei/model/InvoiceModel.dart';
import 'package:imei/model/InvoicePost.dart';

class BankTransferController extends GetxController{
  InvoiceModel _invoiceModel=InvoiceModel();
  InvoiceModel get invoiceModel=>_invoiceModel;

  double _wallet =0.0;
  double get wallet=>_wallet;

  int _count=0;
  int get count=>_count;
  InvoiceModel _bankInvoice = InvoiceModel();
  InvoiceModel get bankInvoice => _bankInvoice;
  bool _done = false;
  bool get done=>_done;

  setCount(counting,bool value)async{
    _count = counting;
    _done =false;
    update();
  }

  setBankInvoice(InvoiceModel invoice)async{
    _bankInvoice = invoice;
    update();
  }


  setInvoiceData(InvoiceModel invoice)async{
    _invoiceModel = invoice;
    print("INVOICE ADDED");
    update();
  }

  setWallet(addedAmount)async{
    // _wallet = double.parse(amount);
    AuthController authController = Get.find<AuthController>();
    CommonController commonController = Get.find<CommonController>();

    double amount = double.parse(authController.userModel!.wallet.toString());
    amount = amount+double.parse(addedAmount.toString());
    await authController.updateWallet(amount);
    await commonController.updateWallet(amount);
    update();
  }


}