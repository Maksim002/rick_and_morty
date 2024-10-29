

abstract class CharacterEvent {} // Абстрактный класс для события персонажа

class FetchCharacters extends CharacterEvent {
  final int page; // Номер страницы для загрузки

  FetchCharacters({this.page = 1}); // Конструктор с параметром по умолчанию
}