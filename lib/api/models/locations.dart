class Locations {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;
  final String url;
  final DateTime created;

  Locations({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      dimension: json['dimension'],
      residents: List<String>.from(json['residents']),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }
}


