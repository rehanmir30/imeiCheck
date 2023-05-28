import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/InvoiceModel.dart';


class InvoiceController extends GetxController{

  List<InvoiceModel>? _invoiceList=[];
  List<InvoiceModel>? get invoiceList=>_invoiceList;

  setInvoiceData(List<InvoiceModel> data)async{
    _invoiceList = data;
    print("Total Invoices: "+_invoiceList!.length.toString());
    update();
  }


}