import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/api/models/episode.dart';
import 'package:rick_and_morty/episode/main/block/episode_event.dart';
import 'package:rick_and_morty/episode/main/block/episode_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final ApiService _apiService;
  final List<Episode> _sendCharacters = [];
  List<Episode> _filteredCharacters = [];
  bool _hasNextPage = true;
  int _currentPage = 1;

  EpisodeBloc(this._apiService) : super(EpisodeInitial()) {
    on<EpisodeEvent>((event, emit) async {
      try {
        if (_sendCharacters.isEmpty) emit(EpisodeLoading());
        if (event is FetchEpisode && _hasNextPage && _sendCharacters.isEmpty) {
          await _fetchAndAddCharacters(emit);
        } else if (event is AddFetchEpisode && _hasNextPage) {
          await _fetchAndAddCharacters(emit);
        }
        filterCharacters(event.value);
      } catch (e) {
        emit(EpisodeError('Data upload error: $e'));
      }
    });
  }

  // Функция загрузки персонажей с сервера и добавления в список
  Future<void> _fetchAndAddCharacters(Emitter<EpisodeState> emit) async {
    final data = await _apiService.fetchEpisodes(_currentPage);
    _sendCharacters.addAll((data['results'] as List)
        .map((json) => Episode.fromJson(json))
        .toList());
    _hasNextPage = data['info']['next'] != null;
    if (_hasNextPage) _currentPage++;
  }

  // Фильтрация персонажей по имени и отправка отфильтрованного списка
  void filterCharacters(String value) {
    _filteredCharacters = _sendCharacters.where((character) {
      return value.isEmpty || character.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
    emit(EpisodeLoaded(dataList: _filteredCharacters, hasNextPage: _hasNextPage));
  }
}
