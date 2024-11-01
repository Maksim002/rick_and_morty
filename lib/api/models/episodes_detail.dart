class EpisodesDetail {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;
  final String url;
  final DateTime created;

  EpisodesDetail({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  // Factory constructor to create an Episode instance from a JSON object
  factory EpisodesDetail.fromJson(Map<String, dynamic> json) {
    return EpisodesDetail(
      id: json['id'],
      name: json['name'],
      airDate: json['air_date'],
      episode: json['episode'],
      characters: List<String>.from(json['characters']),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }

  // Method to convert an Episode instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
      'characters': characters,
      'url': url,
      'created': created.toIso8601String(),
    };
  }
}
