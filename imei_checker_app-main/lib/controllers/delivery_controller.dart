
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryController extends GetxController {
  var switchOneBoolValSendSomething = false.obs;
  var switchTwoBoolValSendSomething =  false.obs;

  var formBoolValSendSomething = false.obs;
  var toBoolValSendSomething = false.obs;

  var docTabBoolValSendSomething = false.obs;
  var parcelTabBoolValSendSomething = false.obs;

  var selectMonthValue, selectDayValue = ''.obs;
  var showDaysBoolVal = false.obs;
  var showTimeBoolVal = false.obs;
  var selectedTime =  const TimeOfDay(hour: 21, minute: 12).obs;
  String? _hours, _mins, _ampm;



}