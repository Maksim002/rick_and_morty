import 'package:flutter/material.dart';
import 'package:rick_and_morty/app.dart';

void main() {
  runApp(const App());
}

/// Всё текстовые подсказки размеры, цвета и.т.д при необходимости можно вынести в единый факел (string.dart, color.dart и т д)
/// Я это не сделал поскольку проект тестовый отставляю комментарии
/// Можно ещё декомпозировать BottomNavPage отделить BlocProvider от GoRoute
/// Так же ждя для разнообразия загрузил картинки в assets гетто использовать url
/// Все комментарии оставлял на русском для удобства чтения так делать нельзя
/// Многие объекты можно вынести такие как (void filterCharacters(String value)) и переиспользовать работы ещё много
/// Widget он выносил чтобы не тратить время
/// Не смог взять с фигмы все иконки нет доступа
/// Так же запросы отличаются от дизайна надеюсь я правильно всё сделал
