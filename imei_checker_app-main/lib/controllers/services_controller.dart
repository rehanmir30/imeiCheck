import 'package:get/get.dart';
import 'package:imei/model/ServicesModel.dart';

import '../model/ServiceCatagoryModel.dart';

class ServicesController extends GetxController{
  List<ServiceModel>? _allServices;
  List<ServiceModel>? get allServices=>_allServices;

  List<ServiceCatagoryModel>? _allData;

  List<ServiceCatagoryModel>? get allData=>_allData;
  setListData(List<ServiceModel> services)async{
    _allServices=services;
    update();
  }

  setAllListData(List<ServiceCatagoryModel> services)async{
    _allData=services;
    update();
  }
}