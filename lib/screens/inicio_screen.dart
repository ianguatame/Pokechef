import 'package:flutter/material.dart';
import '../tema.dart';
import '../models/pokemon.dart';
import '../models/receta.dart';
import '../models/formas.dart';
import '../services/pokeapi_service.dart';
import '../services/mealdb_service.dart';
import 'detalle_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  bool _cargando = false;
  String? _error;
  Pokemon? _pokemon;
  Receta? _receta;

  // initState se ejecuta una vez al abrir la pantalla: carga la primera receta
  @override
  void initState() {
    super.initState();
    _buscarReceta();
  }

  // Pokémon al azar -> su forma -> categoría -> receta al azar de esa categoría
  Future<void> _buscarReceta() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final pokemon = await PokeApiService().pokemonAleatorio();
      final categoria = categoriaDeForma(pokemon.forma);
      final receta = await MealDbService().recetaAleatoriaDeCategoria(categoria);

      if (!mounted) return;
      setState(() {
        _pokemon = pokemon;
        _receta = receta;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar la receta. Revisa tu conexión e inténtalo de nuevo.';
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _construirTarjeta(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _cargando ? null : _buscarReceta,
            icon: const Icon(Icons.casino),
            label: const Text(
              'Receta aleatoria',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colores.amarillo,
              foregroundColor: Colores.texto,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta azul "Receta del día"
    Widget _construirTarjeta() {
    return GestureDetector(
      onTap: () {
        if (_receta == null || _pokemon == null || _cargando) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleScreen(
              id: _receta!.id,
              categoria: _receta!.categoria,
              pokemon: _pokemon,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colores.azul,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _contenidoTarjeta(),
      ),
    );
  }

  Widget _contenidoTarjeta() {
    if (_cargando) {
      return const SizedBox(
        height: 260,
        child: Center(
          child: CircularProgressIndicator(color: Colores.amarillo),
        ),
      );
    }

    if (_error != null || _receta == null || _pokemon == null) {
      return SizedBox(
        height: 260,
        child: Center(
          child: Text(
            _error ?? 'Presiona el botón para descubrir una receta.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final receta = _receta!;
    final pokemon = _pokemon!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Receta del día',
          style: TextStyle(
            color: Colores.amarillo,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            receta.imagen,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          receta.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: pokemon.imagen.isNotEmpty
                  ? NetworkImage(pokemon.imagen)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Basada en ${pokemon.nombre}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}