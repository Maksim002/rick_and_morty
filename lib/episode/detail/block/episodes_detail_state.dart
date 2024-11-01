import 'package:rick_and_morty/api/models/episodes_detail.dart';

// Базовый класс для представления различных состояний загрузки и отображения данных о деталях персонажа
abstract class EpisodesDetailState {}

// Состояние загрузки деталей персонажа (отображает индикатор загрузки)
class EpisodesDetailLoading extends EpisodesDetailState {}

// Состояние, когда детали персонажа успешно загружены
class EpisodesDetailLoaded extends EpisodesDetailState {
  final EpisodesDetail character;

  EpisodesDetailLoaded(this.character);
}

// Состояние ошибки при загрузке данных о деталях персонажа
class EpisodesDetailError extends EpisodesDetailState {
  final String message;

  EpisodesDetailError(this.message);
}