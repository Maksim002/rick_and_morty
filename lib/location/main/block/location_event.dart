
// Базовый класс для событий, связанных с персонажами
class LocationEvent {
  final String value;

  LocationEvent({this.value = ""});
}

// Событие для первой загрузки персонажей
class FetchLocation extends LocationEvent {}

// Событие для добавления следующей страницы персонажей
class AddFetchLocation extends LocationEvent {
  AddFetchLocation({super.value});
}
