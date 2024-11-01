
// Базовый класс для событий, связанных с персонажами
class EpisodeEvent {
  final String value;

  EpisodeEvent({this.value = ""});
}

// Событие для первой загрузки персонажей
class FetchEpisode extends EpisodeEvent {}

// Событие для добавления следующей страницы персонажей
class AddFetchEpisode extends EpisodeEvent {
  AddFetchEpisode({super.value});
}
