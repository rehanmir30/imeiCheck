class OrderModel{

  var id;
  var orderid;
  var status;
  var service;
  var imei;
  var result;
  var notes;
  var credits;
  var username;
  var date;

  OrderModel({
   required this.id,
   required this.orderid,
   required this.status,
   required this.service,
   required this.imei,
   required this.result,
   required this.notes,
   required this.credits,
   required this.username,
   required this.date
});

  factory OrderModel.fromMap(var map) {
    return OrderModel(
        id: map['id'],
        orderid: map['orderid'],
        status: map['status'],
        service: map['service'],
        imei: map["imei"],
        result: map['result'],
        notes: map['notes'],
        credits: map['credits'],
        username: map['username'],
        date:map['date'],

    );
  }
  Map<String,dynamic>toMap(){
    Map<String,dynamic> map=<String,dynamic>{};
    map['id']=id;
    map['orderid']=orderid;
    map['status']=status;
    map['service']=service;
    map["imei"]=imei;
    map['result']=result;
    map['notes']=notes;
    map['credits']=credits;
    map['username']=username;
    map['date']=date;
    return map;
  }

}