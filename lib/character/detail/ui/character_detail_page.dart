import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/api/models/character_detail.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_bloc.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_event.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_state.dart';

class CharacterDetailPage extends StatefulWidget {
  const CharacterDetailPage({super.key, required this.id});

  final int id;

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CharacterDetailBloc>().add(FetchCharacterDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
        builder: (context, state) {
          if (state is CharacterDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterDetailLoaded) {
            return characterDetailContent(context, state.character);
          } else if (state is CharacterDetailError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Нет данных'));
        },
      ),
    );
  }
}

// Функция для создания основной информации о персонаже
Widget characterDetailContent(BuildContext context, CharacterDetail character) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Stack(
    children: [
      backgroundImage(character.image),
      Column(
        children: [
          topAppBar(context),
          Expanded(child: characterInfoContainer(character)),
        ],
      ),
      characterAvatar(character.image, screenHeight, context),
    ],
  );
}

// Функция для создания фонового изображения с прозрачностью
Widget backgroundImage(String imageUrl) {
  return Positioned.fill(
    child: Opacity(
      opacity: 0.3,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    ),
  );
}

// Функция для создания верхней панели с кнопкой "Назад"
Widget topAppBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.3,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black54],
      ),
    ),
    child: SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
    ),
  );
}

// Функция для создания аватара персонажа
Widget characterAvatar(String imageUrl, double screenHeight, BuildContext context) {
  return Positioned(
    top: screenHeight * 0.3 - 100,
    left: MediaQuery.of(context).size.width / 2 - 90,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 80,
        backgroundImage: NetworkImage(imageUrl),
      ),
    ),
  );
}

// Функция для создания контейнера с информацией о персонаже
Widget characterInfoContainer(CharacterDetail character) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 90),
        Text(
          character.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          character.status,
          style: TextStyle(color: character.statusColor(), fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            detailColumn('Пол:', character.gender),
            detailColumn('Вид:', character.species),
          ],
        ),
        const SizedBox(height: 16),
        detailRowWithIcon('Место рождения:', character.origin.name),
        const SizedBox(height: 16),
        detailRowWithIcon('Местоположение:', character.location.name),
      ],
    ),
  );
}

// Функция для создания колонки с заголовком и значением
Widget detailColumn(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 14),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}

// Функция для создания строки с заголовком, значением и иконкой
Widget detailRowWithIcon(String title, String value, {VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        detailColumn(title, value),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black,
        ),
      ],
    ),
  );
}
