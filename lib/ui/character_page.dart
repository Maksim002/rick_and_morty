import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/blocs/character_bloc.dart';
import 'package:rick_and_morty/blocs/character_event.dart';
import 'package:rick_and_morty/blocs/character_state.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Загрузка первой страницы
    context.read<CharacterBloc>().add(FetchCharacters());
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Загрузка следующей страницы при достижении конца списка
      context.read<CharacterBloc>().add(FetchCharacters());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is CharacterLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CharacterLoaded) {
          return Scaffold(
            body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Центрируем содержимое по вертикали
            crossAxisAlignment: CrossAxisAlignment.start,
            // Выравнивание по левому краю
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Цвет фона контейнера
                  borderRadius: BorderRadius.circular(30), // Закругление углов
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // Центрируем элементы по вертикали
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Поиск...',
                          filled: true,
                          fillColor: Colors.grey[200], // Цвет заполнения
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Закругленные углы
                            borderSide: BorderSide.none, // Убираем обводку
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0), // Внутренние отступы
                        ),
                      ),
                    ),
                    // Разделительная линия
                    Container(
                      width: 1, // Толщина черты
                      height: 40, // Высота черты
                      color: Colors.grey, // Цвет черты
                      margin: EdgeInsets.only(left: 8.0), // Отступ слева от черты
                    ),
                    SizedBox(width: 10), // Отступ перед кнопкой фильтра
                    // Кнопка фильтра
                    GestureDetector(
                      onTap: () {
                        // Действие по нажатию на фильтр
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Фильтр'),
                            content: Text('Выберите параметры фильтрации'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Закрыть'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20, // Размер иконки фильтра
                        backgroundColor: Colors.blue, // Цвет фона кнопки фильтра
                        child: Icon(Icons.filter_list, size: 16, color: Colors.white), // Иконка фильтра
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      state.dataList.length + (state.hasNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.dataList.length) {
                      final character = state.dataList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: ClipOval(
                          child: Image.network(
                            character.image,
                            width: 60, // Ширина картинки
                            height: 60, // Высота картинки
                            fit: BoxFit.cover, // Обрезка для заполнения
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "wdw",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 4.0), // Отступ между текстом
                            Text(
                              "dwdw",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 2.0), // Отступ между текстом
                            Text(
                              "wdw",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Показать индикатор загрузки в конце списка
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ));
        } else if (state is CharacterError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        }
        return Center(child: Text('Нет данных'));
      },
    );
  }
}
