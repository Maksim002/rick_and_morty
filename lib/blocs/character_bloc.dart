import 'package:flutter_bloc/flutter_bloc.dart'; // Импорт библиотеки Flutter BLoC для управления состоянием приложения
import 'package:rick_and_morty/blocs/character_event.dart'; // Импорт файла с определением событий для BLoC персонажей
import 'package:rick_and_morty/blocs/character_state.dart'; // Импорт файла с определением состояний для BLoC персонажей
import 'package:rick_and_morty/models/character.dart'; // Импорт модели персонажа, представляющей данные персонажа
import 'package:rick_and_morty/services/api_service.dart'; // Импорт сервиса для работы с API, который предоставляет данные о персонажах

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ApiService _apiService; // Сервис для работы с API
  final List<Character> _sendCharacters = []; // Список для хранения загруженных персонажей
  int _currentPage = 1; // Текущая страница
  bool _hasNextPage = true; // Флаг, указывающий, есть ли следующая страница

  CharacterBloc(this._apiService) : super(CharacterInitial()) { // Конструктор BLoC
    // Обработка событий
    on<CharacterEvent>((event, emit) async {
      if (_sendCharacters.isEmpty) {
        emit(CharacterLoading()); // Изменяем состояние на загрузку
      }
      try {
        // Проверяем, если событие - FetchCharacters и есть следующая страница
        if (event is FetchCharacters && _hasNextPage) {
          // Запрашиваем данные из API
          final data = await _apiService.fetchCharacters(_currentPage);
          // Добавляем загруженные персонажи в список
          _sendCharacters.addAll((data['results'] as List)
              .map((json) => Character.fromJson(json))
              .toList());
          // Проверяем, есть ли следующая страница
          _hasNextPage = data['info']['next'] != null;
          // Увеличиваем номер страницы, если есть следующая
          if (_hasNextPage) _currentPage++;

          // Изменяем состояние на загруженные данные
          emit(CharacterLoaded(
              dataList: _sendCharacters, hasNextPage: _hasNextPage));
        }
      } catch (e) {
        // Если произошла ошибка, изменяем состояние на ошибку
        emit(CharacterError('Ошибка загрузки данных: $e'));
      }
    });
  }
}
