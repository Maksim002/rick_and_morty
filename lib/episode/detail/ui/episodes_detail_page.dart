import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/api/models/episodes_detail.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_bloc.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_event.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_state.dart';

class EpisodesDetailPage extends StatefulWidget {
  const EpisodesDetailPage({super.key, required this.id});

  final int id;

  @override
  State<EpisodesDetailPage> createState() => _EpisodesDetailPageState();
}

class _EpisodesDetailPageState extends State<EpisodesDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<EpisodesDetailBloc>().add(FetchEpisodesDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EpisodesDetailBloc, EpisodesDetailState>(
        builder: (context, state) {
          if (state is EpisodesDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EpisodesDetailLoaded) {
            return characterDetailContent(context, state.character);
          } else if (state is EpisodesDetailError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}

Widget characterDetailContent(BuildContext context, EpisodesDetail character) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Stack(
    children: [
      // Background image taking 30% of screen height
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: screenHeight * 0.4,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://vsthemes.org/uploads/posts/2017-09/1582031275_rick-and-morty_vsthemes_ru-5.webp",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Column(
        children: [
          topAppBar(context),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.20),
              child: characterInfoContainer(character),
            ),
          ),
        ],
      ),
      characterAvatar(
          "https://cdn-icons-png.flaticon.com/512/189/189638.png",
          screenHeight,
          context),
    ],
  );
}

Widget characterAvatar(String imageUrl, double screenHeight, BuildContext context) {
  return Positioned(
    top: screenHeight * 0.22, // Slightly below the background image
    left: MediaQuery.of(context).size.width / 2 - 60, // Center horizontally
    child: CircleAvatar(
      radius: 60,
      backgroundImage: NetworkImage(imageUrl),
    ),
  );
}

Widget topAppBar(BuildContext context) {
  return SafeArea(
    child: Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go('/'),
      ),
    ),
  );
}

Widget characterInfoContainer(EpisodesDetail character) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          character.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          character.episode,
          style: const TextStyle(color: Colors.green, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 40),
        detailRowWithIcon('Air date:', character.airDate),
      ],
    ),
  );
}

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

Widget detailColumn(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}
