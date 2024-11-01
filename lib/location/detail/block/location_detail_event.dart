// Абстрактный класс событий для экрана с деталями персонажа
abstract class LocationDetailEvent {}

// Событие для запроса деталей персонажа по идентификатору
class FetchLocationDetail extends LocationDetailEvent {
  final int id;

  FetchLocationDetail(this.id);
}