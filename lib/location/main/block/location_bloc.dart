import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/api/models/locations.dart';
import 'package:rick_and_morty/location/main/block/location_event.dart';
import 'package:rick_and_morty/location/main/block/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final ApiService _apiService;
  final List<Locations> _sendLocation = [];
  List<Locations> _filteredLocation = [];
  bool _hasNextPage = true;
  int _currentPage = 1;

  LocationBloc(this._apiService) : super(LocationInitial()) {
    on<LocationEvent>((event, emit) async {
      try {
        if (_sendLocation.isEmpty) emit(LocationLoading());
        if (event is FetchLocation && _hasNextPage && _sendLocation.isEmpty) {
          await _fetchAndAddLocation(emit);
        } else if (event is AddFetchLocation && _hasNextPage) {
          await _fetchAndAddLocation(emit);
        }
        filterLocation(event.value);
      } catch (e) {
        emit(LocationError('Data upload error: $e'));
      }
    });
  }

  // Функция загрузки персонажей с сервера и добавления в список
  Future<void> _fetchAndAddLocation(Emitter<LocationState> emit) async {
    final data = await _apiService.fetchLocations(_currentPage);
    _sendLocation.addAll((data['results'] as List)
        .map((json) => Locations.fromJson(json))
        .toList());
    _hasNextPage = data['info']['next'] != null;
    if (_hasNextPage) _currentPage++;
  }

  // Фильтрация персонажей по имени и отправка отфильтрованного списка
  void filterLocation(String value) {
    _filteredLocation = _sendLocation.where((character) {
      return value.isEmpty || character.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
    emit(LocationLoaded(dataList: _filteredLocation, hasNextPage: _hasNextPage));
  }
}
