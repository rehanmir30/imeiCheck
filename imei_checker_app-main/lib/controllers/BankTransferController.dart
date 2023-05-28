import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imei/model/InvoiceModel.dart';
import 'package:imei/model/InvoicePost.dart';

class BankTransferController extends GetxController{
  InvoiceModel _invoiceModel=InvoiceModel();
  InvoiceModel get invoiceModel=>_invoiceModel;

  setInvoiceData(InvoiceModel invoice)async{
    _invoiceModel = invoice;
    print("INVOICE ADDED");
    update();
  }


}