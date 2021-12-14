/// The representation of an internal news, which contains news for people
class InternalNews {
  final int id;
  final String title;
  final String description;
  final DateTime availableFrom;
  final String link;
  final bool published;

  /// Initializes a new instance of [InternalNews].
  ///
  /// Takes different attributes of an internal news as an input.
  InternalNews({
    this.id,
    this.title,
    this.description,
    this.availableFrom,
    this.link,
    this.published,
  });

  /// Initializes a new [InternalNews] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [InternalNews] object in
  /// JSON-Format as an input.
  InternalNews.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        description = json['description'] as String,
        availableFrom = DateTime.parse(json['availableFrom'] as String),
        link = json['link'] as String,
        published = json['published'] as bool;
}
