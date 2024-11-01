import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/api/models/episodes_detail.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_event.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_state.dart';

// Блок управления состояниями экрана с деталями персонажа
class EpisodesDetailBloc extends Bloc<EpisodesDetailEvent, EpisodesDetailState> {
  final ApiService apiService;

  // Конструктор, который инициализирует начальное состояние и регистрирует обработчики событий
  EpisodesDetailBloc(this.apiService) : super(EpisodesDetailLoading()) {
    on<FetchEpisodesDetail>(_fetchEpisodesDetail);
  }

  // Метод для обработки события FetchCharacterDetail, запускает загрузку деталей персонажа
  Future<void> _fetchEpisodesDetail(
      FetchEpisodesDetail event, Emitter<EpisodesDetailState> emit) async {
    emit(EpisodesDetailLoading());
    try {
      final character = await apiService.fetchEpisodesDetail(event.id);
      emit(EpisodesDetailLoaded(EpisodesDetail.fromJson(character)));
    } catch (e) {
      emit(EpisodesDetailError('Failed to load character details'));
    }
  }
}

