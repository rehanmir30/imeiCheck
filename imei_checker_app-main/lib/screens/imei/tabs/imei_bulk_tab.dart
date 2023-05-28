import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/constants.dart';
import 'package:imei/utils/images_path.dart';
import '../../../controllers/common_controller.dart';
import '../../../utils/logger.dart';
import '../../../widgets/app_widgets.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_fields.dart';

class BulkTabWidget extends StatefulWidget {
  BulkTabWidget({Key? key}) : super(key: key);

  @override
  State<BulkTabWidget> createState() => _BulkTabWidgetState();
}

class _BulkTabWidgetState extends State<BulkTabWidget> {
  final tag = 'BulkTabWidget ';
  String? servicesSelectedDropDownValue;
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController _imeiNumberTextEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    Logger.info(tag, 'Inside the initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Logger.info(tag,
          'servicesSelectedDropDownValue ${servicesSelectedDropDownValue.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          CustomTextFieldWithRectBorder(
            filled: true,
            maxlines: 6,
            controller: _imeiNumberTextEditingController,
            filledColor: AppColors.kWhiteColor,
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
            },
          ),




        ],
      ),
    );
  }

  _buildServiceTypeDropDown() {
    return Container(
      height: 50.h,
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
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0, left: 7.0),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isDense: true,
              // focusColor: servicesSelectedDropDownValue   == null
              //     ? AppColors.kWhiteColor
              //     : AppColors.kPrimary,
              isExpanded: true,
              iconEnabledColor: servicesSelectedDropDownValue   == null
                  ? AppColors.kPrimary
                  : AppColors.kWhiteColor,
              dropdownColor: AppColors.kPrimary,
              hint: Text(
                'Select Your Services',
                style: AppTextStyles.grey16w400TextStyle,
              ),
              icon: AppWidgets.image(
                ImagesPath.arrowBlackBottomPNG.toString(),
                height: 30.h,
                width: 30.w,
              ),
              value: servicesSelectedDropDownValue,
              onChanged: (String? newValue) {
                servicesSelectedDropDownValue = newValue ?? '';
                setState(() {});
                Logger.info(tag,
                    'languages Selected DropDown Value - ${servicesSelectedDropDownValue.toString()}');
              },
              items: AppConstant.servicesTypeList.map((Map map) {
                return DropdownMenuItem<String>(
                  value: map["id"].toString(),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            map["name"],
                            style: AppTextStyles.white14TextStyle,
                          )),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
