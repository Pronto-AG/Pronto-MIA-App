import 'package:pronto_mia/core/models/department.dart';

class DeploymentPlan {
  final int id;
  final String description;
  final DateTime availableFrom;
  final DateTime availableUntil;
  final String link;
  final bool published;
  final Department department;

  DeploymentPlan({
    this.id,
    this.description,
    this.availableFrom,
    this.availableUntil,
    this.link,
    this.published,
    this.department,
  });

  DeploymentPlan.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        description = json['description'] as String,
        availableFrom = DateTime.parse(json['availableFrom'] as String),
        availableUntil = DateTime.parse(json['availableUntil'] as String),
        link = json['link'] as String,
        published = json['published'] as bool,
        department = json['department'] as Map<String, dynamic> != null
            ? Department.fromJson(json['department'] as Map<String, dynamic>)
            : null;
}
