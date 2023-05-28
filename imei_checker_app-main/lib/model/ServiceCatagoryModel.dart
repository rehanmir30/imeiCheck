import '../model/ServicesModel.dart';
class ServiceCatagoryModel{
  var id;
  var name;
  var date;
  var position;
  var status;
  List<ServiceModel>? servicesList;

  ServiceCatagoryModel({
   this.id,
   this.name,
   this.date,
   this.position,
    this.status,
      this.servicesList
});

  factory ServiceCatagoryModel.fromMap(var map) {
    return ServiceCatagoryModel(
        id: map['id'],
        name: map['name'],
        date: map['date'],
        position: map['position'],
        status: map["status"],

    );
  }
}

