/// The representation of an external news, which contains news for people
class ExternalNews {
  final int id;
  final String title;
  final String description;
  final DateTime availableFrom;
  final String link;
  final bool published;

  /// Initializes a new instance of [ExternalNews].
  ///
  /// Takes different attributes of an external news as an input.
  ExternalNews({
    this.id,
    this.title,
    this.description,
    this.availableFrom,
    this.link,
    this.published,
  });

  /// Initializes a new [ExternalNews] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [ExternalNews] object in
  /// JSON-Format as an input.
  ExternalNews.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        description = json['description'] as String,
        availableFrom = DateTime.parse(json['availableFrom'] as String),
        link = json['link'] as String,
        published = json['published'] as bool;
}
