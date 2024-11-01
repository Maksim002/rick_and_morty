import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/api/models/character_detail.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_event.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_state.dart';

// Блок управления состояниями экрана с деталями персонажа
class CharacterDetailBloc extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  final ApiService apiService;

  // Конструктор, который инициализирует начальное состояние и регистрирует обработчики событий
  CharacterDetailBloc(this.apiService) : super(CharacterDetailLoading()) {
    on<FetchCharacterDetail>(_fetchCharacterDetail);
  }

  // Метод для обработки события FetchCharacterDetail, запускает загрузку деталей персонажа
  Future<void> _fetchCharacterDetail(
      FetchCharacterDetail event, Emitter<CharacterDetailState> emit) async {
    emit(CharacterDetailLoading());
    try {
      final character = await apiService.fetchCharacter(event.id);
      emit(CharacterDetailLoaded(CharacterDetail.fromJson(character)));
    } catch (e) {
      emit(CharacterDetailError('Failed to load character details'));
    }
  }
}

