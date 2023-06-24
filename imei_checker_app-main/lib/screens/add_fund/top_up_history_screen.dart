

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/InvoiceController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../controllers/common_controller.dart';

import '../../model/InvoiceModel.dart';
import '../../widgets/InvoicePopup.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';

class TopUpHistoryScreen extends StatefulWidget {
  TopUpHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TopUpHistoryScreen> createState() => _TopUpHistoryScreenState();
}

class _TopUpHistoryScreenState extends State<TopUpHistoryScreen> {
  final tag = 'TopUpHistoryScreen ';

  final CommonController controllers = Get.find<CommonController>();

  final AuthController authController = Get.find<AuthController>();

  final TextEditingController _searchTextEditingController = TextEditingController();

  List<InvoiceModel> searchList = [];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'TOP UP HISTORY',
      body: LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor: Colors.amberAccent,
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        onRefresh: () => _handleRefreshState(),
        child: Container(
          margin: AppWidgets.edgeInsetsSymmetric(horizontal: 16),
          child: Column(
            children:  [
              AppWidgets.spacingHeight(15),
              AppWidgets.sizedBoxWidget(
                height: 40.h,
                child: GetBuilder<InvoiceController>(builder: (control) {
                  return CustomTextFieldWithRectBorder(
                    filled: true,
                    suffixIcon: const Icon(Icons.search, color: AppColors.kPrimary,size: 22,),
                    controller: _searchTextEditingController,
                    filledColor: AppColors.kWhiteColor,
                    hintText: "Search",
                    onChanged: (value) async {
                      if(value==""||value==null){
                        await controllers.setInvoiceSearching(false);
                        setState(()  {
                          searchList.clear();

                        });
                      }else{
                        await controllers.setInvoiceSearching(true);
                        if(control.invoiceList!.isNotEmpty){
                          setState(() {
                            searchList = control.invoiceList!
                                .where((order) =>
                            order.paymentMethod.toLowerCase().toString().contains(value.toLowerCase().toString()) || order.totalAmount.toString().contains(value.toString()))
                                .toList();
                          });
                        }
                      }

                    },
                    focusedBorderRadius: 18,
                    enabledBorderRadius: 18,
                  );
                },),
              ),
              AppWidgets.spacingHeight(10),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: GetBuilder<InvoiceController>(builder: (controller) {
                    return (searchList.isEmpty && controllers.searchingInvoices==true)
                        ?Center(child: Text("No Result Found",style: TextStyle(color: Colors.black),))
                        :ListView.builder(
                      shrinkWrap: true,
                        primary: false,
                        reverse: true,
                        itemCount: (controllers.searchingInvoices==false)?controller.invoiceList!.length:searchList.length,
                        itemBuilder: (BuildContext context, int index){
                          return ResultHistoryWidget(
                            status: (controllers.searchingInvoices==false)?controller.invoiceList![index].status.toString():searchList![index].status.toString(),
                            titleId: (controllers.searchingInvoices==false)?controller.invoiceList![index].paymentMethod.toString():searchList![index].paymentMethod.toString(),
                            statusTextStyle: AppTextStyles.green12TextStyle,
                            amountTextShow: true,
                            amountText: '\$${(controllers.searchingInvoices==false)?controller.invoiceList![index].totalAmount.toString():searchList![index].totalAmount.toString()}',
                            invoiceModel: (controllers.searchingInvoices==false)?controller.invoiceList![index]:searchList![index],

                          );

                        });

                  },),
                ),
              ),






            ],
          ),
        ),
      ),


    );




  }

  Future<void>_handleRefreshState()async{
    controllers.getAllInvoices(authController.userModel!);

  }
}
