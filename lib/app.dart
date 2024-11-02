import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/api/api_service.dart';
import 'package:rick_and_morty/character/detail/block/character_detail_bloc.dart';
import 'package:rick_and_morty/character/main/blocs/character_bloc.dart';
import 'package:rick_and_morty/episode/detail/block/episodes_detail_bloc.dart';
import 'package:rick_and_morty/episode/main/block/episode_bloc.dart';
import 'package:rick_and_morty/location/detail/block/location_detail_bloc.dart';
import 'package:rick_and_morty/location/main/block/location_bloc.dart';
import 'package:rick_and_morty/navigation/bottom_nav_page.dart';
import 'Character/detail/ui/character_detail_page.dart';
import 'episode/detail/ui/episodes_detail_page.dart';
import 'location/detail/ui/location_detail_page.dart';

class App extends StatelessWidget {
  const App({super.key});

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
            GoRoute(path: '/', builder: (context, state) => const BottomNavPage()),
            GoRoute(
              path: '/character/:id',
              builder: (context, state) {
                final id = state.params['id']!;
                return CharacterDetailPage(id: int.parse(id));
              },
            ),
            GoRoute(
              path: '/episodes_detail/:id',
              builder: (context, state) {
                final id = state.params['id']!;
                return EpisodesDetailPage(id: int.parse(id));
              },
            ),
            GoRoute(
              path: '/location_detail/:id',
              builder: (context, state) {
                final id = state.params['id']!;
                return LocationDetailPage(id: int.parse(id));
              },
            )
          ],
        ),
      ),
    );
  }
}