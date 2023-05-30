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

import '../../model/OrderModel.dart';
import '../../widgets/OrderTileWidget.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final tag = 'ResultScreen ';

  final CommonController controller = Get.find<CommonController>();

  final TextEditingController _searchTextEditingController = TextEditingController();

  OrderListController orderListController = Get.find<OrderListController>();

  List<OrderModel> searchList = [];
  List<OrderModel> filteredList=[];

  @override
  Widget build(BuildContext context) {
    setState(() {
       filteredList = orderListController.userAllOrders!;
    });
    return CommonScaffold(
      appBarTitle: 'RESULT',
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
                onChanged: (value){
                  if(value==""||value==null){
                    setState(() {
                      searchList.clear();
                    });
                  }else{
                    if(orderListController.userAllOrders!.isNotEmpty){
                    setState(() {
                      searchList =  orderListController.userAllOrders!.where((order) => order.imei.toString().contains(value.toString())).toList();

                    });
                    }
                  }

                },
              ),
            ),
            AppWidgets.spacingHeight(10),
            Expanded(
              child: ListView.builder(
                // scrollDirection: Axis.vertical,
                  primary: true,
                  itemCount:  (searchList.isEmpty)?orderListController.userAllOrders!.length:searchList.length,
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    //
                    // (searchList.isEmpty)?filteredList[index].result=filteredList![index].result.replaceAll("<br>"," "):searchList[index].result=searchList[index].result.replaceAll("<br>"," ");

                    var jsonEncoded=(searchList.isEmpty)?jsonEncode(filteredList![index].result):jsonEncode(searchList[index].result);
                    // print("Helloooo: "+jsonEncoded.toString());
                    return OrderTileWidget(
                      status: (searchList.isEmpty)?filteredList![index].status:searchList[index].status,
                      titleId: (searchList.isEmpty)?filteredList![index].imei:searchList[index].imei,
                      result:  (searchList.isEmpty)?filteredList[index].result:searchList[index].result,
                    );
                  }),
            ),






          ],
        ),
      ),


    );




  }
}
