import 'package:flutter/material.dart';
import 'package:rick_and_morty/character/main/ui/character_page.dart';
import 'package:rick_and_morty/episode/main/ui/episode_page.dart';
import 'package:rick_and_morty/location/main/ui/location_page.dart';

int selectedIndex = 0;

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _NavScreenState();
}

class _NavScreenState extends State<BottomNavPage> {
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> _pages = [
    const CharacterPage(key: PageStorageKey('CharacterPage')),
    const EpisodePage(key: PageStorageKey('EpisodePage')),
    const LocationPage(key: PageStorageKey('LocationPage')),
  ];

  final List<String> _label = [
    'Characters',
    'Episodes',
    'Locations',
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: _pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: _label[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.movie),
            label: _label[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.place),
            label: _label[2],
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}