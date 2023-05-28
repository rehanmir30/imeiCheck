class UserModel{
  var id;
  var userName;
  var name;
  var email;
  var phone;
  var img;
  var wallet;
  var group;
  var role;
  var status;
  var message;

  UserModel({
    required this.id,
    required this.userName,
    this.name,
    required this.email,
    required this.phone,
    this.img,
    required this.wallet,
    required this.group,
    required this.role,
    required this.status,
    required this.message,
});

  factory UserModel.fromMap(var map) {
    return UserModel(
        id: map['id'],
        userName: map['username'],
        name: map['name'],
        email: map['email'],
        phone: map["phone"],
        img: map['img'],
        wallet: map['wallet'],
        group: map['group'],
        role: map['role'],
        status:map['status'],
      message: map['message']
    );
  }

  Map<String,dynamic>toMap(){
    Map<String,dynamic> map=<String,dynamic>{};
    map['id']=id;
    map['username']=userName;
    map['name']=name;
    map['email']=email;
    map["phone"]=phone;
    map['img']=img;
    map['wallet']=wallet;
    map['group']=group;
    map['role']=role;
    map['status']=status;
    map['message']=message;
    return map;
  }

}