
import 'dart:convert';
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

import '../../widgets/app_widgets.dart';
import 'package:html_unescape/html_unescape.dart';


class ResultDetailsScreen extends StatefulWidget {
  var result;
  ResultDetailsScreen(this.result,{Key? key}) : super(key: key);

  @override
  State<ResultDetailsScreen> createState() => _ResultDetailsScreenState();
}

class _ResultDetailsScreenState extends State<ResultDetailsScreen> {
  final tag = 'ResultDetailsScreen ';
  List<String> imei= [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonController controller = Get.find<CommonController>();
    // widget.result = jsonDecode(widget.result).toString();
    get();
    print("Received: "+widget.result.toString());

    imei.add(widget.result);
    if(controller.bulkEmailCheckBoxValue.value==true){
      controller.SendMail(imei);
    }
  }

  get()async{
   await Future.delayed(Duration(milliseconds: 2000),(){

    });
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
            physics: const BouncingScrollPhysics(),
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
                (widget.result==null||widget.result=="")
                    ?Center(child: Text("No Data Found"),)
                    :Container(
                  margin: AppWidgets.edgeInsetsSymmetric(horizontal: 4, vertical: 5),
                  padding: AppWidgets.edgeInsetsAll(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0).r,

                  ),
                  child: HtmlWidget('</p>${HtmlUnescape().convert(widget.result) }</p>',renderMode: RenderMode.column,),


                ),


            ]
        ),

            ),
          ),
        ),



    );




  }
}
