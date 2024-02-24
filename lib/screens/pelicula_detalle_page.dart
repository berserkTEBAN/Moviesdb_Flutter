import 'package:flutter/material.dart';
import 'package:movie_api/model/pelicula_model.dart';
import 'package:movie_api/api/api.dart';

class PeliculaDetalle extends StatelessWidget {
  final Pelicula pelicula;
  final Color backgroundColor;

  const PeliculaDetalle({
    Key? key,
    required this.pelicula,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: Api().getMovieCredits(pelicula.id ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorIndicator(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildNoCreditsIndicator();
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAppbar(context),
                  SizedBox(height: 10.0),
                  _buildPosterAndDetails(),
                  SizedBox(height: 20.0),
                  _buildSinopsis(),
                  SizedBox(height: 20.0),
                  _buildMovieCredits(snapshot.data!['cast']),
                  SizedBox(height: 20.0),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorIndicator(String errorMessage) {
    return Center(
      child: Text('Error: $errorMessage'),
    );
  }

  Widget _buildNoCreditsIndicator() {
    return Center(
      child: Text('No movie credits available.'),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          Image.network(
            pelicula.getBackdropPath(),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            top: 20.0,
            left: 10.0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 20.0,
            right: 20.0,
            child: Text(
              pelicula.title ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterAndDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              pelicula.getPosterPath(),
              fit: BoxFit.cover,
              height: 150.0,
              width: 100.0,
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetalleItem(
                  '**${pelicula.originalTitle}**',
                  '',
                ),
                _buildDetalleItem(
                  'Popularidad',
                  pelicula.popularity.toString(),
                  Icons.favorite,
                  Colors.red,
                ),
                _buildDetalleItem(
                  'Calificación',
                  pelicula.voteAverage.toString(),
                  Icons.star,
                  Colors.yellow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinopsis() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sinopsis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            pelicula.overview ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildDetalleItem(String title, String value,
      [IconData? icon, Color? iconColor]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: iconColor,
              size: 20.0,
            ),
          SizedBox(width: 10.0),
          Text(
            '$title: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCredits(List<dynamic> cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 20),
          child: Text(
            'Reparto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 160.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              final profilePath = actor['profile_path'] as String?;
              final actorName = actor['name'] as String?;
              final characterName = actor['character'] as String?;

              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: profilePath != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w200$profilePath'),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: AssetImage(
                                      'assets/placeholder_image.png'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        actorName ?? '',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        characterName ?? '',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
