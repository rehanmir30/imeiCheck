// To parse this JSON data, do
//
//     final InvoicePostModel = InvoicePostModelFromJson(jsonString);

import 'dart:convert';

InvoicePostModel InvoicePostModelFromJson(String str) => InvoicePostModel.fromJson(json.decode(str));

String InvoicePostModelToJson(InvoicePostModel data) => json.encode(data.toJson());

class InvoicePostModel {
  var username;
  var totalAmount;
  var invDate;
  var dueDate;
  var paymentMethod;
  var status;
  var prof;
  var paymentId;
  var payerId;
  var payerEmail;

  InvoicePostModel({
    this.username,
    this.totalAmount,
    this.invDate,
    this.dueDate,
    this.paymentMethod,
    this.status,
    this.prof,
    this.paymentId,
    this.payerId,
    this.payerEmail,
  });

  factory InvoicePostModel.fromJson(Map<String, dynamic> json) => InvoicePostModel(
    username: json["username"],
    totalAmount: json["total_amount"],
    invDate: json["inv_date"],
    dueDate: json["due_date"],
    paymentMethod: json["payment_method"],
    status: json["status"],
    prof: json["prof"],
    paymentId: json["payment_id"],
    payerId: json["payer_id"],
    payerEmail: json["payer_email"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "total_amount": totalAmount,
    "inv_date": invDate,
    "due_date": dueDate,
    "payment_method": paymentMethod,
    "status": status,
    "prof": prof,
    "payment_id": paymentId,
    "payer_id": payerId,
    "payer_email": payerEmail,
  };
}
