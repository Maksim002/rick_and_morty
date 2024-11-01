import 'package:rick_and_morty/api/models/locations.dart';

// Абстрактный класс, представляющий состояния для управления данными о персонажах
abstract class LocationState {}

// Начальное состояние, указывающее, что нет загруженных данных
class LocationInitial extends LocationState {}

// Состояние загрузки данных, показывающее индикатор загрузки
class LocationLoading extends LocationState {}

// Состояние успешной загрузки данных о персонажах
class LocationLoaded extends LocationState {
  final List<Locations> dataList;
  final bool hasNextPage;

  LocationLoaded({required this.dataList, this.hasNextPage = true});
}

// Состояние ошибки при загрузке данных о персонажах
class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
