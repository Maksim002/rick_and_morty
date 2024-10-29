import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterDetailPage extends StatelessWidget {
  final int id;

  const CharacterDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Здесь загрузите данные персонажа по id
    return Scaffold(
      appBar: AppBar(title: Text('Детали персонажа')),
      body: Center(child: Text('Детальная информация о персонаже с ID: $id')),
    );
  }
}
