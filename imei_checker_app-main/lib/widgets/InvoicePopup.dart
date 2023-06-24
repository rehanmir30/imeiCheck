import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imei/controllers/AdminAccountsController.dart';
import 'package:imei/controllers/common_controller.dart';
import 'package:imei/model/InvoiceModel.dart';
import 'package:imei/utils/helper.dart';
import 'package:imei/widgets/custom_button.dart';

import '../utils/colors.dart';
import '../utils/images_path.dart';
import 'app_widgets.dart';

class InvoicePopup extends StatelessWidget {
  InvoiceModel? invoiceModel;
  InvoicePopup({Key? key,required this.invoiceModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 2, style: BorderStyle.solid, color: AppColors.kPrimary),
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        children: [Container(
          padding: EdgeInsets.all(10),
          // color: Colors.white,
          height: 600,
          width: 600,
          child: Container(
            height: 600,

            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppWidgets.image(
                          ImagesPath.appIcon.toString(), height: 20,),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.close,
                              color: AppColors.kPrimary,),
                          ),
                        )
                      ],),
                    _buildInvoiceDetails(),
                    SizedBox(height: 20),
                    _buildTable(),
                    SizedBox(height: 20),
                    Text('Gateway: ${invoiceModel?.paymentMethod}\n'),
                    if(invoiceModel?.paymentMethod == "Direct Transfer" ||
                        invoiceModel?.paymentMethod == "USDT")
                      Text('Bank Details:', style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),),

                    if(invoiceModel?.paymentMethod == "Direct Transfer")
                      GetBuilder<AdminAcccountsController>(
                          builder: (controller) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.adminBankAccounts.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(children: [
                                        Text("Bank: ", style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),),
                                        Text(controller.adminBankAccounts[index]
                                            .bank.toString()),
                                      ],),
                                      Row(children: [
                                        Text("Account Holder: ",
                                          style: TextStyle(color: Colors.black,
                                              fontWeight: FontWeight.bold),),
                                        Text(controller.adminBankAccounts[index]
                                            .title.toString()),
                                      ],),
                                      Row(children: [
                                        Text("Bank: ", style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),),
                                        Text(controller.adminBankAccounts[index]
                                            .acNum.toString()),
                                      ],),


                                    ],).marginSymmetric(vertical: 15);
                                });
                          }),

                    if(invoiceModel?.paymentMethod == "USDT")
                      const Text(
                          "test_EKm3aFddHE2wwdgnpiRzJ6W_On-99t5UfqdnggfH-tLst4atGq")
                          .marginOnly(top: 10),

                  ],
                ),

                if(invoiceModel?.paymentMethod == "USDT" ||
                    invoiceModel?.paymentMethod == "Direct Transfer")
                  Positioned(
                    bottom: 10,
                    child: CustomButton(
                      buttonWidth: MediaQuery
                          .of(context)
                          .size
                          .width * 0.6,
                      buttonHeight: 40,
                      buttonText: "Upload Proof",
                      buttonTextStyle: TextStyle(fontSize: 18),
                      buttonOnPressed: () {
                        _showImagePickerModal(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        ]
    );
  }

  void _showImagePickerModal(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius:  BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)) ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
          ),
          height: 180,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  CommonController commonController = Get.find<CommonController>();
                   File? file = await commonController.getImageFromGallery();
                   if(file==null){
                     showToast("Please pick image from gallery");
                   }else{
                    await commonController.postData(invoiceModel!.invoiceNo.toString(), file);
                    Get.back();

                   }

                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Capture from Camera'),
                onTap: () async {
                  CommonController commonController = Get.find<CommonController>();
                  File? file = await commonController.captureImageFromCamera();
                  if(file==null){
                    showToast("Please pick image using camera");
                  }else{
                    await commonController.postData(invoiceModel!.invoiceNo.toString(), file);
                    Get.back();

                  }
                },
              ),
            ],
          ),
        );
      },
    );

  }

  Widget _buildInvoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Status: ${invoiceModel?.status}'),
        Text('Bill To: ${invoiceModel?.username}'),
        Text('Invoice No: ${invoiceModel?.invoiceNo}'),
        Text('Invoice Date: ${invoiceModel?.invDate}'),
      ],
    );
  }

  Widget _buildTable() {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1.0),
        1: FlexColumnWidth(2.0),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(1.0),
        4: FlexColumnWidth(1.0),
      },
      border: TableBorder.all(color: Colors.yellow),
      children: [
        TableRow(
          children: [
            _buildTableCell('SN'),
            _buildTableCell('Details'),
            _buildTableCell('Cost'),
            _buildTableCell('Qty'),
            _buildTableCell('Total'),
          ],
        ),
        TableRow(
          children: [
            _buildTableColumn('1'),
            _buildTableColumn('Imei Check Credits'),
            _buildTableColumn('${invoiceModel?.totalAmount}'),
            _buildTableColumn('${invoiceModel?.qty}'),
            _buildTableColumn('${invoiceModel?.totalAmount}'),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String value) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.yellow,
      child: Text(value),
    );
  }
  Widget _buildTableColumn(String value) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: Text(value),
    );
  }
}
