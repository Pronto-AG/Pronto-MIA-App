class DeploymentPlan {
  int get id => _id;
  final int _id;

  String get description => _description;
  final String _description;

  DateTime get availableFrom => _availableFrom;
  final DateTime _availableFrom;

  DateTime get availableUntil => _availableUntil;
  final DateTime _availableUntil;

  String get link => _link;
  final String _link;

  bool get published => _published;
  final bool _published;

  DeploymentPlan(
      this._id,
      this._description,
      this._availableFrom,
      this._availableUntil,
      this._link,
      // ignore: avoid_positional_boolean_parameters
      this._published);

  DeploymentPlan.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _description = json['description'] as String,
        _availableFrom = DateTime.parse(json['availableFrom'] as String),
        _availableUntil = DateTime.parse(json['availableUntil'] as String),
        _link = json['link'] as String,
        _published = json['published'] as bool;
}
