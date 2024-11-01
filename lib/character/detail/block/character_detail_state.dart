import 'package:rick_and_morty/api/models/character_detail.dart';

// Базовый класс для представления различных состояний загрузки и отображения данных о деталях персонажа
abstract class CharacterDetailState {}

// Состояние загрузки деталей персонажа (отображает индикатор загрузки)
class CharacterDetailLoading extends CharacterDetailState {}

// Состояние, когда детали персонажа успешно загружены
class CharacterDetailLoaded extends CharacterDetailState {
  final CharacterDetail character;

  CharacterDetailLoaded(this.character);
}

// Состояние ошибки при загрузке данных о деталях персонажа
class CharacterDetailError extends CharacterDetailState {
  final String message;

  CharacterDetailError(this.message);
}