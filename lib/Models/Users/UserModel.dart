class UserModel {
  int id;
  String name;
  String email;
  String phone;
  List settings;

  UserModel({this.id, this.name, this.email, this.phone, this.settings});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    if (json['settings'] != null) {
      settings = new List();
      json['settings'].forEach((v) {
//        settings.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    if (this.settings != null) {
//      data['settings'] = this.settings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}