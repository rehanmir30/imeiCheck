import  'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/OrderModel.dart';

class OrderListController extends GetxController{
  List<OrderModel>? _userAllOrders;
  List<OrderModel>? get userAllOrders=>_userAllOrders;
  setListData(List<OrderModel> allOrders)async{
    _userAllOrders=allOrders;
    print("COUNT: "+_userAllOrders!.length.toString());
    update();
  }
}

