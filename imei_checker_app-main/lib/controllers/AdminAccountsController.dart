import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imei/model/AdminBankAccuonts.dart';


class AdminAcccountsController extends GetxController{

  List<AdminBankAccountModel> _adminBankAccounts = [];
  List<AdminBankAccountModel> get adminBankAccounts => _adminBankAccounts;


  setBanks(List<AdminBankAccountModel> data)async{
    _adminBankAccounts = data;
    print("Bank Added");
    update();
  }




}