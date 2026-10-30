class UserModel {
  UserModel({
      this.name, 
      this.id, 
      this.email, 
      this.phone, 
      this.avatar, 
      this.wishListMoviesIds,
      this.history,});
  String? name;
  String? id;
  String? email;
  String? phone;
  String? avatar;
  List<String>? wishListMoviesIds;
  List<String>? history;
  UserModel.fromJson(dynamic json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    if (json['watchList'] != null) {
      wishListMoviesIds = [];
      // json['watchList'].forEach((v) {
      //   wishListMoviesIds?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['history'] != null) {
      history = [];
      // json['history'].forEach((v) {
      //   history?.add(Dynamic.fromJson(v));
      // });
    }
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    map['email'] = email;
    map['phone'] = phone;
    map['avatar'] = avatar;
    // if (wishListMoviesIds != null) {
    //   map['watchList'] = wishListMoviesIds?.map((v) => v.toJson()).toList();
    // }
    // if (history != null) {
    //   map['history'] = history?.map((v) => v.toJson()).toList();
    // }
    return map;
  }

}