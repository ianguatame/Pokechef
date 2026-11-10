import 'package:flutter/material.dart';
import 'tema.dart';
import 'screens/inicio_screen.dart';
import 'screens/recetario_screen.dart';
import 'screens/favoritos_screen.dart';


void main() {
  runApp(const PokeChefApp());
}

class PokeChefApp extends StatelessWidget {
  const PokeChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeChef',
      debugShowCheckedModeBanner: false,
            theme: ThemeData(
        scaffoldBackgroundColor: Colores.fondo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colores.rojo,
          primary: Colores.rojo,
          secondary: Colores.amarillo,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colores.rojo,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const Navegacion(),
    );
  }
}

class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  int _indice = 0;

  final List<String> _titulos = ['PokéChef', 'Recetario', 'Favoritos'];

  final List<Widget> _pantallas = const [
    InicioScreen(),
    RecetarioScreen(),
    FavoritosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indice])),
      body: _pantallas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) {
          setState(() {
            _indice = i;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colores.rojo,
        unselectedItemColor: Colores.gris,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Recetario'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}