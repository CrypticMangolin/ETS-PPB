final String filmTable = 'film';

class FilmFields {
  static final List<String> values = [
    id, title, description, link, time
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String link = 'link';
  static final String time = 'time';
}

class Film {
  final int? id;
  final String title;
  final String description;
  final String link;
  final DateTime createdTime;

  const Film({
    this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.createdTime,
  });

  Film copy({
    int? id,
    String? title,
    String? description,
    String? link,
    DateTime? createdTime,
  }) => Film(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    link: link ?? this.link,
    createdTime: createdTime ?? this.createdTime,
  );

  static Film fromJson(Map<String, Object?> json) => Film(
    id: json[FilmFields.id] as int?,
    title: json[FilmFields.title] as String,
    description: json[FilmFields.description] as String,
    link: json[FilmFields.link] as String,
    createdTime: DateTime.parse(json[FilmFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    FilmFields.id: id,
    FilmFields.title: title,
    FilmFields.description: description,
    FilmFields.link: link,
    FilmFields.time: createdTime.toIso8601String(),
  };
}