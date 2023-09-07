import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/OrderListController.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/controllers/services_controller.dart';
import 'package:imei/model/OrderModel.dart';
import 'package:imei/model/ServiceCatagoryModel.dart';
import 'package:imei/model/ServicesModel.dart';
import 'package:imei/screens/imei/qr_scaner_screen.dart';
import 'package:imei/screens/result/result_details_screen.dart';
import 'package:imei/screens/result/result_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/constants.dart';
import 'package:imei/utils/helper.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../../controllers/common_controller.dart';
import '../../../utils/logger.dart';
import '../../../widgets/app_widgets.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_fields.dart';



class SingleTabWidget extends StatefulWidget {
  SingleTabWidget({Key? key}) : super(key: key);

  @override
  State<SingleTabWidget> createState() => _SingleTabWidgetState();
}

class _SingleTabWidgetState extends State<SingleTabWidget> {
  final tag = 'SingleTabWidget ';
  ServiceModel? servicesSelectedDropDownValue;
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController _imeiNumberTextEditingController = TextEditingController();
ServicesController servicesController=Get.find<ServicesController>();


  @override
  void initState() {
    super.initState();
    servicesSelectedDropDownValue=servicesController.allServices![0];
    getServiceCatagories();

    Logger.info(tag, 'Inside the initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Logger.info(tag,
          'servicesSelectedDropDownValue ${servicesSelectedDropDownValue.toString()}');
    });
  }
  getServiceCatagories()async{
    await controller.getServiceCatagories();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          AppWidgets.sizedBoxWidget(
            height: 50.h,
            child: CustomTextFieldWithRectBorder(
              filled: true,
              textInputType: TextInputType.number,
              suffixIcon:  InkWell(
                onTap: () async {
                  _imeiNumberTextEditingController.text =await Get.to(QRViewExample());
                },
                child: Padding(
                  padding:  AppWidgets.edgeInsetsOnly(right: 15),
                  child: AppWidgets.imageSVG(
                    ImagesPath.qrScanBlackIconSVG,
                    height: 27.h,
                    width: 27.w,
                  ),
                ),
              ),
              controller: _imeiNumberTextEditingController,
              filledColor: AppColors.kWhiteColor,
              hintText: "Enter your IMEI Number",
              focusedBorderRadius: 18,
              enabledBorderRadius: 18,
              suffixIconConstraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 0,
              ),
            ),
          ),

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
              List<String> imei= [];
              if(_imeiNumberTextEditingController==null||_imeiNumberTextEditingController.text==""||_imeiNumberTextEditingController.text==null){
                showToast("IMEI number is required");
                return;
              }else{
                AuthController authController = Get.find<AuthController>();
                if(double.parse(authController.userModel!.wallet.toString())<double.parse(selectedService.cost.toString())){
                  showToast("Insufficient amount");
                }else{
                  if(controller.bulkDuplicateCheckBoxValue.value==true){

                    OrderListController orderController = Get.find<OrderListController>();
                    OrderModel? duplicateOrder = findFirstMatch(orderController.userAllOrders!, _imeiNumberTextEditingController.text);
                    if(duplicateOrder?.imei==null||duplicateOrder?.imei==""){
                      showToast("No Imei Found");
                    }else{
                      imei.add(duplicateOrder?.result);
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
                                Get.to(()=>ResultDetailsScreen(duplicateOrder?.result.toString()));
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

                     // if(controller.bulkEmailCheckBoxValue.value==true){
                     //   await controller.SendMail(imei);
                     // }
                    }

                  }else{
                    List<String> imei= [];
                    imei.add(_imeiNumberTextEditingController.text);
                    showLoadingDialog();
                    await controller.findImeiResults(_imeiNumberTextEditingController.text,selectedService);
                    await controller.getAllOrders(authController.userModel!);
                  }
                  // Get.to(()=>ResultScreen());
                }

              }
            },
          ),
          AppWidgets.spacingHeight(8),
          AppWidgets.text('SCAN IMEI NUMBER',
              style: AppTextStyles.black15TextStyle
          ),
          AppWidgets.spacingHeight(10),
          InkWell(
            onTap: () async {
              _imeiNumberTextEditingController.text =await Get.to(QRViewExample());
            },
            child: Container(
              height: 60.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor,
                borderRadius:  BorderRadius.all(Radius.circular(15.0).r),
                border: Border.all(
                  width: 1,
                  color: AppColors.kPrimary,
                  style: BorderStyle.solid,
                ),),
              child: AppWidgets.image(
                ImagesPath.qrScanIconPNG,


              ),
            ),
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
            : AppColors.kPrimary,
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
                                      
                                      trailing: (Get.find<CommonController>().bankKeyModel?.stripeSecretKey=="true")
                                      ?Text('')
                                      :Text(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Expanded(
                flex: 3,
                child: Text((selectedService.name==""||selectedService.name==null)
                ?"Select you service":selectedService.name.toString(),style: TextStyle(color: Colors.white),)),

                (Get.find<CommonController>().bankKeyModel?.stripeSecretKey=="true")
                ?Text('')
                :Text((selectedService.price==""||selectedService.price==null)?"":selectedService.cost.toString(),style: TextStyle(color: Colors.white),).marginOnly(left: 10), Image.asset("assets/icons/png/arrow_black_bottomPNG.png")],),
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
class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  String expandedValue;
  bool isExpanded;
}
