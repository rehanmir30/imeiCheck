import 'dart:convert';

List<AdminBankAccountModel> adminBankAccountModelFromJson(String str) => List<AdminBankAccountModel>.from(json.decode(str).map((x) => AdminBankAccountModel.fromJson(x)));

String adminBankAccountModelToJson(List<AdminBankAccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminBankAccountModel {
  var id;
  var bank;
  var title;
  var acNum;
  var date;

  AdminBankAccountModel({
     this.id,
     this.bank,
     this.title,
     this.acNum,
     this.date,
  });

  factory AdminBankAccountModel.fromJson(Map<String, dynamic> json) => AdminBankAccountModel(
    id: json["id"],
    bank: json["bank"],
    title: json["title"],
    acNum: json["ac_num"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bank": bank,
    "title": title,
    "ac_num": acNum,
    "date": date.toIso8601String(),
  };
}
