import 'package:rick_and_morty/api/models/character.dart';

// Абстрактный класс, представляющий состояния для управления данными о персонажах
abstract class CharacterState {}

// Начальное состояние, указывающее, что нет загруженных данных
class CharacterInitial extends CharacterState {}

// Состояние загрузки данных, показывающее индикатор загрузки
class CharacterLoading extends CharacterState {}

// Состояние успешной загрузки данных о персонажах
class CharacterLoaded extends CharacterState {
  final List<Character> dataList;
  final bool hasNextPage;

  CharacterLoaded({required this.dataList, this.hasNextPage = true});
}

// Состояние ошибки при загрузке данных о персонажах
class CharacterError extends CharacterState {
  final String message;

  CharacterError(this.message);
}
