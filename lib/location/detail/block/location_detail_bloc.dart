import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/api/models/location_detail.dart';
import 'package:rick_and_morty/location/detail/block/location_detail_event.dart';
import 'package:rick_and_morty/location/detail/block/location_detail_state.dart';

// Блок управления состояниями экрана с деталями персонажа
class LocationDetailBloc extends Bloc<LocationDetailEvent, LocationDetailState> {
  final ApiService apiService;

  // Конструктор, который инициализирует начальное состояние и регистрирует обработчики событий
  LocationDetailBloc(this.apiService) : super(LocationDetailLoading()) {
    on<FetchLocationDetail>(_fetchLocationDetail);
  }

  // Метод для обработки события FetchCharacterDetail, запускает загрузку деталей персонажа
  Future<void> _fetchLocationDetail(
      FetchLocationDetail event, Emitter<LocationDetailState> emit) async {
    emit(LocationDetailLoading());
    try {
      final character = await apiService.fetchLocationsDetail(event.id);
      emit(LocationDetailLoaded(LocationDetail.fromJson(character)));
    } catch (e) {
      emit(LocationDetailError('Failed to load character details'));
    }
  }
}

