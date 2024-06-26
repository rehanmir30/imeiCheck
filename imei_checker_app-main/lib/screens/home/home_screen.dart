import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as strip;
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:imei/controllers/OrderListController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../controllers/common_controller.dart';
import '../../controllers/services_controller.dart';
import '../../utils/helper.dart';
import '../../widgets/OrderTileWidget.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';

import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart';

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
    strip.Stripe.publishableKey = "${controller.bankKeyModel!.stripePublishableKey}";
    setWalletValue();
  }
  setWalletValue(){
    authController.userModel?.wallet =double.tryParse(authController.userModel!.wallet.toString());
    // print(authController.userModel?.wallet.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'DASH BOARD',
      body: LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor: Colors.amberAccent,
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        onRefresh: () => _handleRefreshState(),
        child: SingleChildScrollView(
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
                              (Get.find<CommonController>().bankKeyModel?.stripeSecretKey=="true")
                              ?Container()
                              :_topCards(
                                imagesPath: ImagesPath.cardOrangePNG,
                                titleText: 'Credits',
                                detailsText:
                                    '\$ ${authController.userModel!.wallet.toStringAsFixed(2)}',
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
                      ? Container(child: Text("No Text"),)
                      : ListView.builder(
                          itemCount: controller.userAllOrders!.length > 10
                              ? 10
                              : controller.userAllOrders!.length,
                          shrinkWrap: true,
                          primary: false,
                          // reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            return OrderTileWidget(
                              status: orderListController
                                  .userAllOrders![index].status,
                              titleId:
                                  orderListController.userAllOrders![index].imei,
                              result: orderListController.userAllOrders![index].result,
                            );
                          });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void>_handleRefreshState()async{
    controller.getAllOrders(authController.userModel!);

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
