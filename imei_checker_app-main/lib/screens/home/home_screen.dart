import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:imei/controllers/OrderListController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';
import '../../controllers/services_controller.dart';
import '../../utils/helper.dart';
import '../../widgets/OrderTileWidget.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final tag = 'HomeScreen ';

  AuthController authController = Get.find<AuthController>();
  OrderListController orderListController = Get.find<OrderListController>();

  final CommonController controller = Get.find<CommonController>();
  final ServicesController servicesController = Get.find<ServicesController>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'DASH BOARD',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: AppWidgets.edgeInsetsSymmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<OrderListController>(
                builder: (controller) {
                  return (controller.userAllOrders == null)
                      ? Container()
                      : Column(
                          children: [
                            AppWidgets.spacingHeight(10),
                            _topCards(
                              imagesPath: ImagesPath.arrowUpperOrange,
                              titleText: 'IMEI Check',
                              detailsText:
                                  controller.userAllOrders!.length.toString(),
                            ),
                            _topCards(
                              imagesPath: ImagesPath.cardOrangePNG,
                              titleText: 'Credits',
                              detailsText:
                                  '\$ ${authController.userModel!.wallet}',
                            ),
                            _topCards(
                              imagesPath: ImagesPath.eyeOrangePNG,
                              titleText: 'Fraud Eye Status',
                              detailsText: 'Clear',
                            ),
                            AppWidgets.spacingHeight(10),
                            Row(
                              children: [
                                AppWidgets.text(
                                  'Result History',
                                  style: AppTextStyles.black18W600TextStyle,
                                ),
                              ],
                            ),
                            AppWidgets.spacingHeight(10),
                          ],
                        );
                },
              ),
              GetBuilder<OrderListController>(builder: (controller) {
                return (controller.userAllOrders == null)
                    ? Container()
                    : ListView.builder(
                        itemCount: controller.userAllOrders!.length > 10
                            ? 10
                            : controller.userAllOrders!.length,
                        shrinkWrap: true,
                        primary: true,
                        itemBuilder: (BuildContext context, int index) {
                          //
                          orderListController.userAllOrders![index].result=orderListController.userAllOrders![index].result.replaceAll("<br>"," ");

                          var jsonEncoded=jsonEncode(orderListController.userAllOrders![index].result);
                          print("Helloooo: "+jsonEncoded.toString());
                          return OrderTileWidget(
                            status: orderListController
                                .userAllOrders![index].status,
                            titleId:
                                orderListController.userAllOrders![index].imei,
                          );
                        });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Center _topCards({
    String? imagesPath,
    titleText,
    detailsText,
  }) {
    return Center(
      child: AppWidgets.sizedBoxWidget(
          height: 90,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: AppColors.kPrimary,
              ),
              borderRadius: BorderRadius.circular(20.0).r,
            ),
            child: Container(
              margin: AppWidgets.edgeInsetsSymmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppWidgets.image(
                    imagesPath.toString(),
                    height: 50.h,
                    width: 50.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppWidgets.text(
                        titleText.toString(),
                        style: AppTextStyles.black14BoldTextStyle,
                      ),
                      AppWidgets.spacingHeight(12),
                      AppWidgets.text(
                        detailsText.toString(),
                        style: AppTextStyles.black12TextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
