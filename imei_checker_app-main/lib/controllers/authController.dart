import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imei/model/UserModel.dart';

class AuthController extends GetxController{
  UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  setUserData(UserModel user)async{
    _userModel=user;
    update();
  }
  updateWallet(wallet)async{
    _userModel?.wallet = wallet;
    update();
  }
}