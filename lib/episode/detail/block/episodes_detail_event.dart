// Абстрактный класс событий для экрана с деталями персонажа
abstract class EpisodesDetailEvent {}

// Событие для запроса деталей персонажа по идентификатору
class FetchEpisodesDetail extends EpisodesDetailEvent {
  final int id;

  FetchEpisodesDetail(this.id);
}