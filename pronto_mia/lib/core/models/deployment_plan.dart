import 'package:pronto_mia/core/models/department.dart';

/// A representation of a deployment plan, which contains work for employees to
/// do.
class DeploymentPlan {
  final int id;
  final String description;
  final DateTime availableFrom;
  final DateTime availableUntil;
  final String link;
  final bool published;
  final Department department;

  /// Initializes a new instance of [DeploymentPlan].
  ///
  /// Takes different attributes of a deployment plan as an input.
  DeploymentPlan({
    this.id,
    this.description,
    this.availableFrom,
    this.availableUntil,
    this.link,
    this.published,
    this.department,
  });

  /// Initializes a new [DeploymentPlan] from a JSON format object.
  ///
  /// Takes a [Map] representing a JSON object as an input.
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
