import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/services/api_service.dart';
import 'package:rick_and_morty/ui/character_detail_page.dart';
import 'blocs/character_bloc.dart';
import 'ui/character_page.dart';
import 'ui/episode_page.dart';
import 'ui/location_page.dart';

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
        // BlocProvider(create: (context) => EpisodeBloc(ApiService())),
        // BlocProvider(create: (context) => LocationBloc(ApiService())),
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
            GoRoute(path: '/character/:id', builder: (context, state) {
              final id = state.params['id']!;
              return CharacterDetailPage(id: int.parse(id));
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
    'Персонажи',
    'Эпизоды',
    'Локации',
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
