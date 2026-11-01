class UserModel {
  static UserModel? loggedInUser;
  String? name;
  String? id;
  String? email;
  String? phone;
  String? avatarName;
  List<Map<String, dynamic>>? wishListMovies;
  List<Map<String, dynamic>>? watchedMovies;
  UserModel({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    this.avatarName,
    List<Map<String, dynamic>>? wishListMoviesIds,
    List<Map<String, dynamic>>? watchedMoviesIds,
  }) : watchedMovies = watchedMoviesIds ?? [], wishListMovies = wishListMoviesIds ?? [];


  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    avatarName = json['avatar'];
    wishListMovies = List<Map<String, dynamic>>.from(json['watchList'] ?? const []);
    watchedMovies = List<Map<String, dynamic>>.from(json['history'] ?? const []);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'phone': phone,
      'avatar': avatarName,
      'watchList': wishListMovies,
      'history': watchedMovies,
    };
  }
}
