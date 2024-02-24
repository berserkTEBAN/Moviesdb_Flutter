class Pelicula {
  int? voteCount;
  int? id;
  bool? video;
  double? voteAverage;
  String? title;
  double? popularity;
  String? posterPath;
  String? originalLanguage;
  String? originalTitle;
  List<int>? genreIds;
  String? backdropPath;
  bool? adult;
  String? overview;
  String? overviewPath;
  String? releaseDate;

  Pelicula({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  });

  factory Pelicula.fromJsonMap(Map<String, dynamic> json) {
    return Pelicula(
      voteCount: json['vote_count'],
      id: json['id'],
      video: json['video'],
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      title: json['title'],
      popularity: json['popularity']?.toDouble() ?? 0.0,
      posterPath: json['poster_path'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      genreIds: json['genre_ids']?.cast<int>(),
      backdropPath: json['backdrop_path'],
      adult: json['adult'],
      overview: json['overview'],
      releaseDate: json['release_date'],
    );
  }

  get cast => null;

  // Método para obtener el póster inicial de la película
  String getPosterPath() {
    return posterPath != null
        ? 'https://image.tmdb.org/t/p/w500/$posterPath'
        : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png';
  }

  // Método para obtener la película secundaria
  String getBackdropPath() {
    return backdropPath != null
        ? 'https://image.tmdb.org/t/p/w500/$backdropPath'
        : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png';
  }
}

class Peliculas {
  List<Pelicula> items;

  Peliculas({required this.items});

  factory Peliculas.fromJsonList(List<dynamic> jsonList) {
    return Peliculas(
      items: jsonList.map((item) => Pelicula.fromJsonMap(item)).toList(),
    );
  }
}
