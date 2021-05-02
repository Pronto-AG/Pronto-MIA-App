class User {
  int get id => _id;
  final int _id;

  String get username => _username;
  final String _username;

  User(this._id, this._username);
}
