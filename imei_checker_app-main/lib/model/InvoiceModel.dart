// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

List<InvoiceModel> invoiceModelFromJson(String str) => List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));

String invoiceModelToJson(List<InvoiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceModel {
  var id;
  var username;
  var invoiceNo;
  var item;
  var qty;
  var totalAmount;
  var invDate;
  var dueDate;
  var suplyDate;
  var paymentMethod;
  var status;
  var prof;
  var paymentId;
  var payerId;
  var payerEmail;
  var date;

  InvoiceModel({
    this.id,
    this.username,
    this.invoiceNo,
    this.item,
    this.qty,
    this.totalAmount,
    this.invDate,
    this.dueDate,
    this.suplyDate,
    this.paymentMethod,
    this.status,
    this.prof,
    this.paymentId,
    this.payerId,
    this.payerEmail,
    this.date,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    id: json["id"],
    username: json["username"],
    invoiceNo: json["invoice_no"],
    item: json["item"],
    qty: json["qty"],
    totalAmount: json["total_amount"],
    invDate: json["inv_date"],
    dueDate: json["due_date"],
    suplyDate: json["suply_date"],
    paymentMethod: json["payment_method"],
    status: json["status"],
    prof: json["prof"],
    paymentId: json["payment_id"],
    payerId: json["payer_id"],
    payerEmail: json["payer_email"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "invoice_no": invoiceNo,
    "item": item,
    "qty": qty,
    "total_amount": totalAmount,
    "inv_date": invDate,
    "due_date": dueDate,
    "suply_date": suplyDate,
    "payment_method": paymentMethod,
    "status": status,
    "prof": prof,
    "payment_id": paymentId,
    "payer_id": payerId,
    "payer_email": payerEmail,
    "date": date.toIso8601String(),
  };
}
