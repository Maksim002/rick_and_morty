import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/character/main/blocs/character_bloc.dart';
import 'package:rick_and_morty/character/main/blocs/character_event.dart';
import 'package:rick_and_morty/character/main/blocs/character_state.dart';

// Виджет для содержимого страницы персонажей
class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageContentState();
}

class _CharacterPageContentState extends State<CharacterPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  String? _filter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CharacterBloc>().add(FetchCharacters(_filter));
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      context
          .read<CharacterBloc>()
          .add(AddFetchCharacters(_filter, value: _controller.text));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CharacterBloc, CharacterState>(
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
      ),
    );
  }

  // Поле поиска с фильтрацией персонажей
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TextField(
            controller: _controller,
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
              setState(() =>  value);
              context.read<CharacterBloc>().filterCharacters(value);
            },
          ),
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  _scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 50),
                      curve: Curves.easeInOut);
                  _showFilterDialog();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Диалог для выбора фильтра
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterOption('unknown', 'Filtering by unknown'),
              _filterOption('Alive', 'Filter by Alive'),
              _filterOption('Dead', 'Filtering by Dead'),
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

  // Кнопка фильтрации
  TextButton _filterOption(String? filterValue, String text) {
    return TextButton(
      onPressed: () {
        setState(() => _filter = filterValue);
        _controller.clear();
        context.read<CharacterBloc>()
            .add(FetchCharacters(_filter, isChanges: true));
        Navigator.of(context).pop();
      },
      child: Text(text),
    );
  }

  // Список персонажей
  Widget _buildCharacterList(CharacterLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.dataList.length + (state.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.dataList.length) {
          return _buildCharacterTile(state.dataList[index]);
        } else {
          if (state.dataList.length >= 10) {
            return const Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  // Элемент списка персонажей
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
          Text(character.status,
              style: TextStyle(color: character.statusColor(), fontSize: 14.0)),
          const SizedBox(height: 4.0),
          Text(character.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          const SizedBox(height: 2.0),
          Text("${character.gender}, ${character.species}",
              style: TextStyle(color: Colors.grey[700], fontSize: 12.0)),
        ],
      ),
      onTap: () => context.go('/character/${character.id}'),
    );
  }
}
