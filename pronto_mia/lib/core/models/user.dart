class User {
  final int id;
  final String username;

  User({this.id, this.username});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        description = json['username'] as String,
        accessControlList = AccessControlList.fromJson(json['accessControlList']);
}
