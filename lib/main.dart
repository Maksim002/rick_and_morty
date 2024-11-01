import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/Character/detail/ui/character_detail_page.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_bloc.dart';
import 'package:rick_and_morty/character/main/blocs/character_bloc.dart';
import 'package:rick_and_morty/character/main/ui/character_page.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_bloc.dart';
import 'package:rick_and_morty/episode/detail/ui/episodes_detail_page.dart';
import 'package:rick_and_morty/episode/main/block/episode_bloc.dart';
import 'package:rick_and_morty/episode/main/ui/episode_page.dart';
import 'package:rick_and_morty/location/detail/block/location_detail_bloc.dart';
import 'package:rick_and_morty/location/detail/ui/location_detail_page.dart';
import 'package:rick_and_morty/location/main/block/location_bloc.dart';
import 'package:rick_and_morty/location/main/ui/location_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CharacterBloc(ApiService())),
        BlocProvider(create: (context) => CharacterDetailBloc(ApiService())),
        BlocProvider(create: (context) => EpisodeBloc(ApiService())),
        BlocProvider(create: (context) => EpisodesDetailBloc(ApiService())),
        BlocProvider(create: (context) => LocationBloc(ApiService())),
        BlocProvider(create: (context) => LocationDetailBloc(ApiService()))
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
            GoRoute(path: '/character_page', builder: (context, state) => const CharacterPage()),
            GoRoute(path: '/episode_page', builder: (context, state) => const EpisodePage()),
            GoRoute(path: '/character/:id', builder: (context, state) {
              final id = state.params['id']!;
              return CharacterDetailPage(id: int.parse(id));
            }),
            GoRoute(path: '/episodes_detail/:id', builder: (context, state) {
              final id = state.params['id']!;
              return EpisodesDetailPage(id: int.parse(id));
            }),
            GoRoute(path: '/location_detail/:id', builder: (context, state) {
              final id = state.params['id']!;
              return LocationDetailPage(id: int.parse(id));
            })
          ],
        ),
          title: 'Rick and Morty'
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CharacterPage(),
    const EpisodePage(),
    const LocationPage(),
  ];

  final List<String> _label = [
    'Characters',
    'Episodes',
    'Locations',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_label[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: _label[_selectedIndex],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.movie),
            label: _label[_selectedIndex],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.place),
            label: _label[_selectedIndex],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
