
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';
import 'package:imei/utils/constants.dart';
import 'package:imei/utils/images_path.dart';

import 'package:imei/widgets/common_scaffold.dart';

import '../../controllers/common_controller.dart';

import '../../model/OrderModel.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/result_history.dart';
import '../../widgets/text_fields.dart';

class BulkResultDetailScreen extends StatefulWidget {
  List<dynamic> result;
  BulkResultDetailScreen(this.result,{Key? key}) : super(key: key);

  @override
  State<BulkResultDetailScreen> createState() => _BulkResultDetailScreenState();
}

class _BulkResultDetailScreenState extends State<BulkResultDetailScreen> {
  final tag = 'BulkResultDetailScreen ';
  List<String> imei = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SendMail();
  }

  SendMail()async{
    CommonController controller = Get.find<CommonController>();
    for(var i in widget.result){
      imei.add(i+"<br><br>");
    }
    if(controller.bulkEmailCheckBoxValue.value==true){
     await controller.SendMail(imei);
    }
  }

  // final CommonController controller = Get.find<CommonController>();
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBarTitle: 'RESULT',
      body: Container(
        margin: AppWidgets.edgeInsetsSymmetric(
          horizontal: 20, vertical: 25,
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            side:  const BorderSide(
              color: AppColors.kPrimary,
            ),
            borderRadius: BorderRadius.circular(20.0).r,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: AppWidgets.edgeInsetsAll(10),
                      child:
                      GestureDetector(
                        onTap: ()async{
                          Get.back();
                        },
                        child: AppWidgets.icon(Icons.close_rounded, color: AppColors.kGreenColor, size: 24.w),

                      ),
                    ),

                  ],
                ),

                Container(
                  margin: AppWidgets.edgeInsetsSymmetric(horizontal: 4, vertical: 5),
                  padding: AppWidgets.edgeInsetsAll(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0).r,

                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                    return HtmlWidget(widget.result[index]??"No Simialar data Found");
                  }, separatorBuilder: (context, index) {
                    return Divider(height: 2,color: Colors.black.withOpacity(0.4),);

                  }, itemCount: widget.result.length),


                ),

              ],
            ),
          ),
        ),
      ),


    );
  }
}
