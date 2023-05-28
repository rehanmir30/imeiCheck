class ServiceModel{

  var id;
  var name;
  var link;
  var price;
  var cost;
  var status;
  var date;
  var category;
  var position;

  ServiceModel({
    this.id,
    this.name,
    this.link,
    this.price,
    this.status,
    this.date,
    this.category,
    this.position
});

  factory ServiceModel.fromMap(var map) {
    return ServiceModel(
        id: map['id'],
        name: map['name'],
        link: map['link'],
        price: map['price'],
        status: map['status'],
        date: map['date'],
        category: map['category'],
        position: map['position']
    );
  }

  Map<String,dynamic>toMap(){
    Map<String,dynamic> map=<String,dynamic>{};
    map['id']=id;
    map['name']=name;
    map['link']=link;
    map['price']=price;
    map['status']=status;
    map['date']=date;
    map['category']=category;
    map['position']=position;
    return map;
  }

}