import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_api/api/api.dart';
import 'package:movie_api/model/pelicula_model.dart';
import 'package:movie_api/screens/pelicula_detalle_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Pelicula>> upcomingMovies;
  late Future<List<Pelicula>> popularMovies;
  late Future<List<Pelicula>> topRatedMovies;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final api = Api();
    upcomingMovies = api.getUpcomingMovies();
    popularMovies = api.getPopularMovies();
    topRatedMovies = api.getTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Color.fromARGB(
              255, 154, 14, 4), // Color rojo de fondo para el AppBar
          foregroundColor: const Color.fromARGB(255, 113, 106, 106),
          leading: PopupMenuButton(
            icon: Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Ajustes'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Luis Felipe Cruz Esteban :)'),
                value: 2,
              ),
              PopupMenuItem(
                child: Text('Dart'),
                value: 3,
              ),
            ],
          ),
          title: const Text("Peliculas"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _toggleBackgroundColor();
                });
              },
              icon: Icon(Icons.color_lens),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieCategory("Populares", popularMovies, true),
              _buildMovieCategory("Peliculas Populares", topRatedMovies, false),
              _buildUpcomingMovies(),
            ],
          ),
        ),
      ),
    );
  }

  Color _scaffoldColor =
      Colors.black12.withOpacity(0.5); // Color inicial del Scaffold

  void _toggleBackgroundColor() {
    setState(() {
      _scaffoldColor = _scaffoldColor == Colors.black12.withOpacity(0.5)
          ? Colors.white.withOpacity(0.5)
          : Colors.black12.withOpacity(0.5);
    });
  }

  Widget _buildMovieCategory(
      String title, Future<List<Pelicula>> movies, bool isPopular) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: isPopular ? 250 : 200,
          child: FutureBuilder(
            future: movies,
            builder: (context, AsyncSnapshot<List<Pelicula>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final movies = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PeliculaDetalle(
                            pelicula: movie,
                            backgroundColor: _scaffoldColor,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isPopular
                            ? [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          movie.getPosterPath(),
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMovies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Proximamente',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder(
          future: upcomingMovies,
          builder: (context, AsyncSnapshot<List<Pelicula>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final movies = snapshot.data!;

            return CarouselSlider.builder(
              itemCount: movies.length,
              itemBuilder: (context, index, movieIndex) {
                final movie = movies[index];
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    movie.getBackdropPath(),
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 1.8,
                autoPlayInterval: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }
}
