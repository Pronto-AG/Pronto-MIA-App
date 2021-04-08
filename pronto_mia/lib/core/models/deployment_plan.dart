class DeploymentPlan {
  int get id => _id;
  final int _id;

  DateTime get availableFrom => _availableFrom;
  final DateTime _availableFrom;

  DateTime get availableUntil => _availableUntil;
  final DateTime _availableUntil;

  String get link => _link;
  final String _link;

  DeploymentPlan(
      this._id, this._availableFrom, this._availableUntil, this._link);

  DeploymentPlan.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _availableFrom = DateTime.parse(json['availableFrom'] as String),
        _availableUntil = DateTime.parse(json['availableUntil'] as String),
        _link = json['link'] as String;
}
