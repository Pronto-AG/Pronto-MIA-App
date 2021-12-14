/// The representation of an appointment
class Appointment {
  final int id;
  final String title;
  final String location;
  final DateTime from;
  final DateTime to;
  final bool isAllDay;
  final bool isYearly;

  /// Initializes a new instance of [Appointment].
  ///
  /// Takes different attributes of an appointment as an input.
  Appointment({
    this.id,
    this.title,
    this.location,
    this.from,
    this.to,
    this.isAllDay,
    this.isYearly,
  });

  /// Initializes a new [Appointment] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [Appointment] object in
  /// JSON-Format as an input.
  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        location = json['location'] as String,
        from = DateTime.parse(json['from'] as String),
        to = DateTime.parse(json['to'] as String),
        isAllDay = json['isAllDay'] as bool,
        isYearly = json['isYearly'] as bool;
}
