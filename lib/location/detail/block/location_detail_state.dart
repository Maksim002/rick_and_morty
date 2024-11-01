import 'package:rick_and_morty/api/models/location_detail.dart';

// Базовый класс для представления различных состояний загрузки и отображения данных о деталях персонажа
abstract class LocationDetailState {}

// Состояние загрузки деталей персонажа (отображает индикатор загрузки)
class LocationDetailLoading extends LocationDetailState {}

// Состояние, когда детали персонажа успешно загружены
class LocationDetailLoaded extends LocationDetailState {
  final LocationDetail character;

  LocationDetailLoaded(this.character);
}

// Состояние ошибки при загрузке данных о деталях персонажа
class LocationDetailError extends LocationDetailState {
  final String message;

  LocationDetailError(this.message);
}