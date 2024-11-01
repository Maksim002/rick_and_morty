// Абстрактный класс событий для экрана с деталями персонажа
abstract class CharacterDetailEvent {}

// Событие для запроса деталей персонажа по идентификатору
class FetchCharacterDetail extends CharacterDetailEvent {
  final int id;

  FetchCharacterDetail(this.id);
}