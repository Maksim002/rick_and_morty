import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/character/main/blocs/character_event.dart';
import 'package:rick_and_morty/character/main/blocs/character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ApiService _apiService;
  final List<Character> _sendCharacters = [];
  List<Character> _filteredCharacters = [];
  bool _hasNextPage = true;
  int _currentPage = 1;

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
        emit(CharacterError('Data upload error: $e'));
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
