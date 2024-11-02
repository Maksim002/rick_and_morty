import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/api/models/episode.dart';
import 'package:rick_and_morty/episode/main/block/episode_bloc.dart';
import 'package:rick_and_morty/episode/main/block/episode_event.dart';
import 'package:rick_and_morty/episode/main/block/episode_state.dart';

// Виджет для содержимого страницы персонажей
class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key});

  @override
  State<EpisodePage> createState() => _CharacterPageContentState();
}

class _CharacterPageContentState extends State<EpisodePage> {
  final ScrollController _scrollController = ScrollController();
  String _value = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<EpisodeBloc>().add(FetchEpisode());
  }

  void _onScroll() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      context.read<EpisodeBloc>().add(AddFetchEpisode(value: _value));
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
      child: BlocBuilder<EpisodeBloc, EpisodeState>(
        builder: (context, state) {
          if (state is EpisodeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EpisodeLoaded) {
            return Scaffold(
              body: Column(
                children: [
                  _buildSearchField(context),
                  Expanded(child: _buildCharacterList(state)),
                ],
              ),
            );
          } else if (state is EpisodeError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  // Поле поиска и кнопка фильтрации
  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find a episode',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _value = value);
                context.read<EpisodeBloc>().filterCharacters(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Список персонажей
  Widget _buildCharacterList(EpisodeLoaded state) {
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
  ListTile _buildCharacterTile(Episode character) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
       leading: ClipOval(
         child: Image.asset(
           "assets/play.png", width: 60, height: 60, fit: BoxFit.cover,
         ),
       ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(character.episode, style: const TextStyle(color: Colors.green, fontSize: 14.0)),
          const SizedBox(height: 4.0),
          Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          const SizedBox(height: 2.0),
          Text(character.airDate, style: TextStyle(color: Colors.grey[700], fontSize: 12.0)),
        ],
      ),
      onTap: () => context.go('/episodes_detail/${character.id}'), // Переход на экран деталей персонажа
    );
  }
}
