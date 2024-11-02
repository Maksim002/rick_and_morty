import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/api/models/locations.dart';
import 'package:rick_and_morty/location/main/block/location_bloc.dart';
import 'package:rick_and_morty/location/main/block/location_event.dart';
import 'package:rick_and_morty/location/main/block/location_state.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageContentState();
}

class _LocationPageContentState extends State<LocationPage> {
  final ScrollController _scrollController = ScrollController();
  String _value = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<LocationBloc>().add(FetchLocation());
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      context.read<LocationBloc>().add(AddFetchLocation(value: _value));
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
      child:  BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationLoaded) {
            return Scaffold(
              body: Column(
                children: [
                  _buildSearchField(context),
                  Expanded(child: _buildLocationList(state)),
                ],
              ),
            );
          } else if (state is LocationError) {
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
                hintText: 'Find a location',
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
                context.read<LocationBloc>().filterLocation(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Список локаций
  Widget _buildLocationList(LocationLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.dataList.length + (state.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.dataList.length) {
          if (index % 2 != 0) {
            return _buildLocationTile(state.dataList[index],
                "https://img.freepik.com/free-photo/glowing-sky-sphere-orbits-starry-galaxy-generated-by-ai_188544-15599.jpg");
          } else {
            return _buildLocationTile(state.dataList[index],
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu1INW7Qclp2JKKXsDQUsPKUJqH2YTlHaj5w&s");
          }
        } else {
          if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
            return const Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  // Элемент списка локаций с изображением и контейнером с описанием
  Widget _buildLocationTile(Locations location, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Padding around each item
      child: GestureDetector(
        onTap: () => context.go('/location_detail/${location.id}'),
        child: ClipRRect(
          // ClipRRect to apply rounded corners to the entire item
          borderRadius: BorderRadius.circular(16), // Fully rounded corners
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Image with full width
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Description container with rounded corners
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(1),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "${location.type}.",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          location.dimension,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
