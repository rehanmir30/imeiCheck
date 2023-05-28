import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/OrderListController.dart';
import '../../controllers/common_controller.dart';

import '../../widgets/OrderTileWidget.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({Key? key}) : super(key: key);
  final tag = 'ResultScreen ';
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController _searchTextEditingController = TextEditingController();
  OrderListController orderListController = Get.find<OrderListController>();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'Result',
      body: Container(
        margin: AppWidgets.edgeInsetsSymmetric(horizontal: 16),
        child: Column(
          children:  [
            AppWidgets.spacingHeight(15),
            AppWidgets.sizedBoxWidget(
              height: 40.h,
              child: CustomTextFieldWithRectBorder(
                filled: true,
                suffixIcon: const Icon(Icons.search, color: AppColors.kPrimary,size: 22,),
                controller: _searchTextEditingController,
                filledColor: AppColors.kWhiteColor,
                hintText: "Enter IMEI Number",
                focusedBorderRadius: 18,
                enabledBorderRadius: 18,
              ),
            ),
            AppWidgets.spacingHeight(10),
            Expanded(
              child: ListView.builder(
                  itemCount:  orderListController.userAllOrders!.length,
                  shrinkWrap: true,
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
                  }),
            ),






          ],
        ),
      ),


    );




  }


}
