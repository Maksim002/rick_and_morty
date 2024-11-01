import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/blocs/character_event.dart';
import 'package:rick_and_morty/blocs/character_state.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/services/api_service.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ApiService _apiService; // Сервис для работы с API персонажей
  final List<Character> _sendCharacters = []; // Список всех загруженных персонажей
  List<Character> _filteredCharacters = []; // Список персонажей после фильтрации
  bool _hasNextPage = true; // Флаг наличия следующей страницы
  int _currentPage = 1; // Текущая страница для загрузки

  CharacterBloc(this._apiService) : super(CharacterInitial()) {
    on<CharacterEvent>((event, emit) async {
      _validChanges(event);
      try {
        if (_sendCharacters.isEmpty) emit(CharacterLoading());
        if (event is FetchCharacters && _hasNextPage && _sendCharacters.isEmpty) {
          await _fetchAndAddCharacters(event.filter, emit);
        } else if (event is AddFetchCharacters && _hasNextPage) {
          await _fetchAndAddCharacters(event.filter, emit);
        }
        filterCharacters(event.value);
      } catch (e) {
        emit(CharacterError('Ошибка загрузки данных: $e'));
      }
    });
  }

  // Функция загрузки персонажей с сервера и добавления в список
  Future<void> _fetchAndAddCharacters(String? filter, Emitter<CharacterState> emit) async {
    final data = await _apiService.fetchCharacters(_currentPage, filter);
    _sendCharacters.addAll((data['results'] as List)
        .map((json) => Character.fromJson(json))
        .toList());
    _hasNextPage = data['info']['next'] != null;
    if (_hasNextPage) _currentPage++;
  }

  // Фильтрация персонажей по имени и отправка отфильтрованного списка
  void filterCharacters(String value) {
    _filteredCharacters = _sendCharacters.where((character) {
      return value.isEmpty || character.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
    emit(CharacterLoaded(dataList: _filteredCharacters, hasNextPage: _hasNextPage));
  }

  // Сброс данных, если была изменена фильтрация или другой значимый параметр
  void _validChanges(CharacterEvent event) {
    if (event.isChanges!) {
      _sendCharacters.clear();
      _hasNextPage = true;
      _currentPage = 1;
    }
  }
}
