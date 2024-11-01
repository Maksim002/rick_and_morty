import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/blocs/character_bloc.dart';
import 'package:rick_and_morty/blocs/character_event.dart';
import 'package:rick_and_morty/blocs/character_state.dart';
import 'package:rick_and_morty/models/character.dart';

// Экран для отображения и поиска персонажей
class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onScroll);
  String? _filter;
  String _value = "";

  @override
  void initState() {
    super.initState();
    // Инициализируем загрузку персонажей при открытии экрана
    context.read<CharacterBloc>().add(FetchCharacters(_filter));
  }

  // Обработчик для автоматической подгрузки данных при достижении конца списка
  void _onScroll() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      context
          .read<CharacterBloc>()
          .add(AddFetchCharacters(_filter, value: _value));
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
              children: [
                _buildSearchField(),
                Expanded(child: _buildCharacterList(state)),
              ],
            ),
          );
        } else if (state is CharacterError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No data available'));
      },
    );
  }

  // Показ диалогового окна для выбора фильтрации
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterOption('Unknown', 'Filtering by name'),
              _filterOption('Alive', 'Filter by status'),
              _filterOption('Dead', 'Filtering by gender'),
              _filterOption(null, 'Search for everyone'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Создание кнопок для выбора фильтра
  TextButton _filterOption(String? filterValue, String text) {
    return TextButton(
      onPressed: () {
        setState(() => _filter = filterValue); // Обновляем фильтр
        context.read<CharacterBloc>().add(FetchCharacters(_filter, isChanges: true)); // Запуск фильтрации
        Navigator.of(context).pop();
      },
      child: Text(text),
    );
  }

  // Поле поиска с фильтрацией персонажей
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find a character',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _value = value); // Обновляем текст фильтра
                context.read<CharacterBloc>().filterCharacters(value); // Применяем фильтр
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
    );
  }

  // Список персонажей с возможностью подгрузки
  Widget _buildCharacterList(CharacterLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.dataList.length + (state.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.dataList.length) {
          return _buildCharacterTile(state.dataList[index]);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Метод создания элемента списка с переходом на экран деталей через GoRouter с использованием id
  ListTile _buildCharacterTile(Character character) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      leading: ClipOval(
        child: Image.network(
          character.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(character.status, style: TextStyle(color: character.statusColor(), fontSize: 14.0)),
          const SizedBox(height: 4.0),
          Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          const SizedBox(height: 2.0),
          Text("${character.gender}, ${character.species}", style: TextStyle(color: Colors.grey[700], fontSize: 12.0)),
        ],
      ),
      onTap: () {
        // Переход на экран деталей с использованием GoRouter и передачи id персонажа в URL
        context.go('/character/${character.id}');
      },
    );
  }
}
