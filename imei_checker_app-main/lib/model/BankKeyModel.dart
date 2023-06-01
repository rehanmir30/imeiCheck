import 'dart:convert';

List<BankKeyModel> bankKeyModelFromMap(String str) => List<BankKeyModel>.from(json.decode(str).map((x) => BankKeyModel.fromMap(x)));

String bankKeyModelToMap(List<BankKeyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BankKeyModel {
  String? id;
  String? stripeSecretKey;
  String? stripePublishableKey;
  String? paypalClientId;
  String? paypalClientSecret;
  String? usdtAddress;
  String? sStatus;
  DateTime? date;

  BankKeyModel({
    this.id,
    this.stripeSecretKey,
    this.stripePublishableKey,
    this.paypalClientId,
    this.paypalClientSecret,
    this.usdtAddress,
    this.sStatus,
    this.date,
  });

  factory BankKeyModel.fromMap(Map<String, dynamic> json) => BankKeyModel(
    id: json["id"],
    stripeSecretKey: json["stripe_secret_key"],
    stripePublishableKey: json["stripe_publishable_key"],
    paypalClientId: json["paypal_CLIENT_ID"],
    paypalClientSecret: json["paypal_CLIENT_SECRET"],
    usdtAddress: json["usdt_address"],
    sStatus: json["s_status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "stripe_secret_key": stripeSecretKey,
    "stripe_publishable_key": stripePublishableKey,
    "paypal_CLIENT_ID": paypalClientId,
    "paypal_CLIENT_SECRET": paypalClientSecret,
    "usdt_address": usdtAddress,
    "s_status": sStatus,
    "date": date?.toIso8601String(),
  };
}
