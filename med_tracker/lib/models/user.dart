class User {
  final String? id;
  final String? email;
  final String? password;
  final String? name;
  final String? profilePicture;
  final int? v;

  User({
    this.id,
    this.email,
    this.password,
    this.name,
    this.profilePicture,
    this.v,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        name = json['name'] as String?,
        profilePicture = json['profilePicture'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'password': password,
    'name': name,
    'profilePicture': profilePicture,
    '__v': v,
  };
}
