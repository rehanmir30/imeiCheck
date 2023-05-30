import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imei/controllers/AdminAccountsController.dart';
import 'package:imei/model/InvoiceModel.dart';

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
        side: BorderSide(width: 2,style: BorderStyle.solid,color: AppColors.kPrimary),
        borderRadius: BorderRadius.circular(10),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      children: [Container(
        padding: EdgeInsets.all(10),
        // color: Colors.white,
        height: 600,
          width: 600,
          child: Container(
            height:  600,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    AppWidgets.image(ImagesPath.appIcon.toString(), height: 20,),
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.close,color: AppColors.kPrimary,),
                      ),
                    )],),
                _buildInvoiceDetails(),
                SizedBox(height: 20),
                _buildTable(),
                SizedBox(height: 20),
                Text('Gateway: ${invoiceModel?.paymentMethod}\n'),
                if(invoiceModel?.paymentMethod=="Direct Transfer"||invoiceModel?.paymentMethod=="USDT")
                  Text('Bank Details:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                if(invoiceModel?.paymentMethod=="Direct Transfer")
                GetBuilder<AdminAcccountsController>(builder: (controller){
                  return ListView.builder(
                    shrinkWrap: true,
                      itemCount: controller.adminBankAccounts.length,
                      itemBuilder: (context,index){
                        return Column(
                          children: [
                            Row(children: [Text("Bank: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),), Text(controller.adminBankAccounts[index].bank.toString()),],),
                            Row(children: [Text("Account Holder: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),), Text(controller.adminBankAccounts[index].title.toString()),],),
                            Row(children: [Text("Bank: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),), Text(controller.adminBankAccounts[index].acNum.toString()),],),


                          ],).marginSymmetric(vertical: 15);

                      });
                }),

                if(invoiceModel?.paymentMethod=="USDT")
                  const Text("test_EKm3aFddHE2wwdgnpiRzJ6W_On-99t5UfqdnggfH-tLst4atGq").marginOnly(top: 10),
              ],
            ),
          ),
        ),]
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
