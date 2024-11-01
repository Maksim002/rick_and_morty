import 'package:flutter/material.dart';

class CharacterDetail {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final Location origin;
  final Location location;
  final List<String> episodeUrls;

  CharacterDetail({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.origin,
    required this.location,
    required this.episodeUrls,
  });

  factory CharacterDetail.fromJson(Map<String, dynamic> json) {
    return CharacterDetail(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      gender: json['gender'],
      image: json['image'],
      origin: Location.fromJson(json['origin']),
      location: Location.fromJson(json['location']),
      episodeUrls: List<String>.from(json['episode']),
    );
  }

  MaterialColor statusColor() {
    switch (status) {
      case "Dead":
        return Colors.red;
      case "Alive":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class Location {
  final String name;
  final String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String ,
      url: json['url'] as String ,
    );
  }
}
