
// Базовый класс для событий, связанных с персонажами
class CharacterEvent {
  final String? filter;
  final bool? isChanges;
  final String? value;

  CharacterEvent(this.filter, {this.isChanges = false, this.value = ""});
}

// Событие для первой загрузки персонажей
class FetchCharacters extends CharacterEvent {
  FetchCharacters(super.filter, {super.isChanges, super.value});
}

// Событие для добавления следующей страницы персонажей
class AddFetchCharacters extends CharacterEvent {
  AddFetchCharacters(super.filter, {super.value});
}
