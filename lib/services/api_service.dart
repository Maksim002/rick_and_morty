import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<Map<String, dynamic>> fetchCharacters(int page, String? status) async {
    final response = await _dio.get('$_baseUrl/character',
        queryParameters: {'page': page, 'status': status});
    return response.data;
  }

  Future<Map<String, dynamic>> fetchEpisodes(int page, String status) async {
    final response = await _dio.get('$_baseUrl/episode',
        queryParameters: {'page': page, 'status': status});
    return response.data;
  }

  Future<Map<String, dynamic>> fetchLocations(int page, String status) async {
    final response = await _dio.get('$_baseUrl/location',
        queryParameters: {'page': page, 'status': status});
    return response.data;
  }
}
