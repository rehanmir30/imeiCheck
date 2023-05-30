import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/screens/result/BulkResultDetailScreen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/constants.dart';
import 'package:imei/utils/helper.dart';
import 'package:imei/utils/images_path.dart';
import '../../../controllers/OrderListController.dart';
import '../../../controllers/common_controller.dart';
import '../../../controllers/services_controller.dart';
import '../../../model/OrderModel.dart';
import '../../../model/ServiceCatagoryModel.dart';
import '../../../model/ServicesModel.dart';
import '../../../utils/logger.dart';
import '../../../widgets/app_widgets.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_fields.dart';
import '../../result/result_details_screen.dart';

class BulkTabWidget extends StatefulWidget {
  BulkTabWidget({Key? key}) : super(key: key);

  @override
  State<BulkTabWidget> createState() => _BulkTabWidgetState();
}

class _BulkTabWidgetState extends State<BulkTabWidget> {
  final tag = 'BulkTabWidget ';
  ServiceModel? servicesSelectedDropDownValue;
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController _imeiNumberTextEditingController = TextEditingController();
  ServicesController servicesController=Get.find<ServicesController>();



  @override
  void initState() {
    super.initState();
    servicesSelectedDropDownValue=servicesController.allServices![0];
    Logger.info(tag, 'Inside the initState');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Logger.info(tag,
          'servicesSelectedDropDownValue ${servicesSelectedDropDownValue.toString()}');
    });
  }
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          CustomTextFieldWithRectBorder(
            focusNode: _focusNode,
            filled: true,
            maxlines: 6,
            controller: _imeiNumberTextEditingController,
            filledColor: AppColors.kWhiteColor,
            textInputType: TextInputType.multiline,
            hintText: "Enter your IMEI Number",
            focusedBorderRadius: 18,
            enabledBorderRadius: 18,
          ),
          AppWidgets.spacingHeight(8),

          _buildServiceTypeDropDown(),
          AppWidgets.spacingHeight(10),
          Row(
            children: [
              Obx(() =>  Checkbox(
                  value: controller.bulkDuplicateCheckBoxValue.value,
                  activeColor: AppColors.kPrimary,
                  onChanged:(bool? newValue){
                    controller.bulkDuplicateCheckBoxValue.value = newValue! ;
                  })),
              AppWidgets.text('Duplicate',
                  style: AppTextStyles.black12TextStyle
              )
            ],
          ),
          Row(
            children: [
              Obx(() =>  Checkbox(
                  value: controller.bulkEmailCheckBoxValue.value,
                  activeColor: AppColors.kPrimary,
                  onChanged:(bool? newValue){
                    controller.bulkEmailCheckBoxValue.value = newValue! ;
                  })),
              AppWidgets.text('Email',
                  style: AppTextStyles.black12TextStyle
              )
            ],
          ),
          AppWidgets.spacingHeight(15),

          CustomButton(
            buttonHeight: 50.h,
            buttonWidth: 360.w,
            buttonText: "Search IMEI",
            buttonColor: AppColors.kPrimary,
            borderRadius: BorderRadius.circular(15.0).r,
            buttonTextStyle: AppTextStyles.black18W600TextStyle,
            buttonOnPressed: () async {
              if(controller.bulkDuplicateCheckBoxValue.value==true){
                showLoadingDialog();
                OrderListController orderController = Get.find<OrderListController>();
                CommonController commonController = Get.find<CommonController>();
                List<String> lines = _imeiNumberTextEditingController.text.split('\n');
                commonController.duplicateBulkList.clear();
                for(var line in lines){
                  OrderModel? duplicateOrder = await findFirstMatch(orderController.userAllOrders!, line);
                  await commonController.setDuplicateBulkData(duplicateOrder?.result);
                }
                if(commonController.duplicateBulkList.length==null||commonController.duplicateBulkList.length==""){
                  showToast("No Imei Found");
                  closeLoadingDialog();
                }else{
                  closeLoadingDialog();
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Similar Imei Found"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(borderRadius: BorderRadius.circular(20),
                            buttonColor: AppColors.kPrimary,
                            buttonText: "View Result",
                            buttonWidth: MediaQuery.of(context).size.width,
                            buttonOnPressed: () {
                              Get.to(()=>BulkResultDetailScreen(commonController.duplicateBulkList));
                            },
                          ),
                          CustomButton(borderRadius: BorderRadius.circular(20),
                            buttonColor: AppColors.kPrimary,
                            buttonText: "Cancel",
                            buttonWidth: MediaQuery.of(context).size.width,
                            buttonOnPressed: () {
                              Navigator.pop(context);
                            },
                          )

                        ],),
                    );
                  },);
                }

              }else{
                _focusNode.unfocus();
                AuthController auth = Get.find<AuthController>();
                showLoadingDialog();
                List<String> lines = _imeiNumberTextEditingController.text.split('\n');
                controller.bulkList.clear();
                for (String line in lines) {
                  await controller.findImeiBulkResults(line,selectedService);
                }
                closeLoadingDialog();
                controller.getAllOrders(auth.userModel!);
                Get.to(()=>BulkResultDetailScreen(controller.bulkList));
              }

            },
          ),




        ],
      ),
    );
  }

  ServiceModel selectedService = ServiceModel();

  _buildServiceTypeDropDown() {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: servicesSelectedDropDownValue == null
            ? AppColors.kWhiteColor
            : Colors.white,
        borderRadius:  BorderRadius.all(Radius.circular(15.0).r),
        border: Border.all(
          width: 1,
          color: AppColors.kPrimary,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: (){
          showDialog(context: context, builder: (builder){
            return AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.all(0),
              backgroundColor: AppColors.kPrimary,

              title: Text('Select a service'),
              titlePadding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              content: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.kPrimary, borderRadius: BorderRadius.all(Radius.circular(15.0).r)),
                    height: 500,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: ListView(
                      shrinkWrap: true,
                      children: servicesController.allData!.map<Widget>((ServiceCatagoryModel item) {
                        return ExpansionPanelList.radio(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.all(0),
                          initialOpenPanelValue: item,
                          // canTapOnHeader: true,
                          children: [
                            ExpansionPanelRadio(
                              backgroundColor: AppColors.kPrimary,
                              value: item,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                );
                              },
                              body: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: item.servicesList!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      onTap: (){
                                        setState(() {
                                          selectedService = item.servicesList![index];
                                        });
                                        Navigator.pop(context);
                                      },
                                      title:  Text(
                                        item.servicesList![index].name.toString(),
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                      trailing: Text(
                                        "\$ "+item.servicesList![index].cost.toString(),
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                      // title: Text("List item $index")
                                    );
                                  }),

                              canTapOnHeader: true,
                            ),
                            //
                            //),
                          ],
                        );
                      }).toList(),
                    ),
                  )
              ),
            );
          });

        },
        child: Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(flex: 3,child: Text((selectedService.name==""||selectedService.name==null)?"Select you service":selectedService.name.toString(),style: TextStyle(color: Colors.black),)),Text((selectedService.price==""||selectedService.price==null)?"":selectedService.cost.toString(),style: TextStyle(color: Colors.black),).marginOnly(left: 10), Image.asset("assets/icons/png/arrow_black_bottomPNG.png")],),
        ).marginAll(15),
      ),
    );
  }

  OrderModel? findFirstMatch(List<OrderModel> items, String searchTerm) {
    for (OrderModel item in items) {
      if (item.imei.contains(searchTerm)) {
        return item;
      }
    }
    return null;
  }

}
