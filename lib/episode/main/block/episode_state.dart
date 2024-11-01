import 'package:rick_and_morty/api/models/episode.dart';

// Абстрактный класс, представляющий состояния для управления данными о персонажах
abstract class EpisodeState {}

// Начальное состояние, указывающее, что нет загруженных данных
class EpisodeInitial extends EpisodeState {}

// Состояние загрузки данных, показывающее индикатор загрузки
class EpisodeLoading extends EpisodeState {}

// Состояние успешной загрузки данных о персонажах
class EpisodeLoaded extends EpisodeState {
  final List<Episode> dataList;
  final bool hasNextPage;

  EpisodeLoaded({required this.dataList, this.hasNextPage = true});
}

// Состояние ошибки при загрузке данных о персонажах
class EpisodeError extends EpisodeState {
  final String message;

  EpisodeError(this.message);
}
