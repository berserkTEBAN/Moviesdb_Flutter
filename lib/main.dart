import 'package:flutter/material.dart';
import 'package:movie_api/screens/pelicula_detalle_page.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get pelicula => null;

  Widget build(BuildContext context) {
    var _scaffoldColor;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: 'home',
      routes: {
        'home': (context) => Home(),
        'detalle': (context) => PeliculaDetalle(
              pelicula: pelicula,
              backgroundColor: _scaffoldColor,
            ),
      },
    );
  }
}
