class UserModel {
  static UserModel? loggedInUser;
  String? name;
  String? id;
  String? email;
  String? phone;
  String? avatarName;
  List<String>? wishListMoviesIds;
  List<String>? watchedMoviesIds;
  UserModel({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    this.avatarName,
    List<String>? wishListMoviesIds,
    List<String>? watchedMoviesIds,
  }) : watchedMoviesIds = watchedMoviesIds ?? [], wishListMoviesIds = wishListMoviesIds ?? [];


  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    avatarName = json['avatar'];
    wishListMoviesIds = List<String>.from(json['watchList'] ?? const []);
    watchedMoviesIds = List<String>.from(json['history'] ?? const []);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'phone': phone,
      'avatar': avatarName,
      'watchList': wishListMoviesIds,
      'history': watchedMoviesIds,
    };
  }
}
