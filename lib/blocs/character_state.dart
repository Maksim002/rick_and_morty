import 'package:rick_and_morty/models/character.dart'; // Импорт модели персонажа

abstract class CharacterState {} // Абстрактный класс для состояния персонажа

class CharacterInitial extends CharacterState {} // Начальное состояние

class CharacterLoading extends CharacterState {} // Состояние загрузки

class CharacterLoaded extends CharacterState {
  final List<Character> dataList; // Список загруженных персонажей
  final bool hasNextPage; // Флаг, указывающий, есть ли следующая страница

  CharacterLoaded({required this.dataList, this.hasNextPage = true}); // Конструктор
}

class CharacterError extends CharacterState {
  final String message; // Сообщение об ошибке

  CharacterError(this.message); // Конструктор
}
