import 'package:get/get.dart';
import 'package:imei/controllers/AdminAccountsController.dart';
import 'package:imei/controllers/InvoiceController.dart';
import 'package:imei/controllers/OrderListController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/controllers/services_controller.dart';

import '../BankTransferController.dart';
import '../common_controller.dart';
import '../delivery_controller.dart';

class ControllersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CommonController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(OrderListController(), permanent: true);
    Get.put(ServicesController(), permanent: true);
    Get.put(AdminAcccountsController(),permanent: true);
    Get.put(InvoiceController(),permanent: true);
    Get.put(BankTransferController(),permanent: true);
  }
}