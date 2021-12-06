/// The representation of an educational content
class EducationalContent {
  final int id;
  final String title;
  final String description;
  final String link;
  final bool published;

  /// Initializes a new instance of [EducationalContent].
  ///
  /// Takes different attributes of an educational content as an input.
  EducationalContent({
    this.id,
    this.title,
    this.description,
    this.link,
    this.published,
  });

  /// Initializes a new [EducationalContent] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [EducationalContent] object in
  /// JSON-Format as an input.
  EducationalContent.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        description = json['description'] as String,
        link = json['link'] as String,
        published = json['published'] as bool;
}
