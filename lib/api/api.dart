import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pelicula_model.dart';

class Api {
  final String apiKey = '058b3fd7d78f8dd6830738c70b954eec';
  final String baseUrl = 'https://api.themoviedb.org/3/movie';
  final String language = 'es'; // Idioma español

  Future<List<Pelicula>> getUpcomingMovies() async {
    final String upcomingApiUrl =
        '$baseUrl/upcoming?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(upcomingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Pelicula> movies =
          data.map((movie) => Pelicula.fromJsonMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Pelicula>> getPopularMovies() async {
    final String popularApiUrl =
        '$baseUrl/popular?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Pelicula> movies =
          data.map((movie) => Pelicula.fromJsonMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Pelicula>> getTopRatedMovies() async {
    final String topRatedApiUrl =
        '$baseUrl/top_rated?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Pelicula> movies =
          data.map((movie) => Pelicula.fromJsonMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    final String creditsApiUrl = '$baseUrl/$movieId/credits?api_key=$apiKey';

    final response = await http.get(Uri.parse(creditsApiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie credits');
    }
  }
}
