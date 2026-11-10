import 'package:flutter/material.dart';
import '../tema.dart';
import '../models/pokemon.dart';
import '../models/receta.dart';
import '../services/pokeapi_service.dart';
import '../services/mealdb_service.dart';
import '../widgets/anatomia_badge.dart';
import '../services/favoritos_service.dart';

class DetalleScreen extends StatefulWidget {
  final String id;
  final String categoria;
  final Pokemon? pokemon; // si ya viene uno (desde Inicio), se usa ese

  const DetalleScreen({
    super.key,
    required this.id,
    required this.categoria,
    this.pokemon,
  });

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  bool _cargando = true;
  String? _error;
  Receta? _receta;
  Pokemon? _pokemon;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final receta = await MealDbService().recetaPorId(widget.id);
      final pokemon = widget.pokemon ??
          await PokeApiService().pokemonDeCategoria(widget.categoria);

      if (!mounted) return;
      setState(() {
        _receta = receta;
        _pokemon = pokemon;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar la receta. Inténtalo de nuevo.';
        _cargando = false;
      });
    }
  }

  // Divide las instrucciones en pasos (una línea = un paso)
  List<String> _pasos(String texto) {
    final List<String> pasos = [];
    for (final linea in texto.split(RegExp(r'[\r\n]+'))) {
      final limpia = linea.trim();
      final soloNumero =
          RegExp(r'^(step\s*)?\d+\.?$', caseSensitive: false).hasMatch(limpia);
      if (limpia.isNotEmpty && !soloNumero) {
        pasos.add(limpia);
      }
    }
    return pasos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receta')),
      body: _construirContenido(),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: Colores.rojo));
    }

    if (_error != null || _receta == null || _pokemon == null) {
      return Center(child: Text(_error ?? 'Algo salió mal.'));
    }

    final receta = _receta!;
    final pokemon = _pokemon!;
    final pasos = _pasos(receta.instrucciones);
    final porciones =
        pokemon.porciones == 1 ? '1 porción' : '${pokemon.porciones} porciones';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto del plato
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              receta.imagen,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Nombre de la receta
          Text(
            receta.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colores.texto,
            ),
          ),
          const SizedBox(height: 8),

          // Pokémon en que se basa
          Row(
            children: [
              Expanded(
                child: Text(
                  receta.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colores.texto,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    FavoritosService.alternar(receta, pokemon);
                  });
                },
                icon: Icon(
                  FavoritosService.esFavorito(receta.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colores.rojo,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ficha de anatomía
          Row(
            children: [
              Expanded(
                child: AnatomiaBadge(valor: pokemon.colorEs, etiqueta: 'Color'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnatomiaBadge(valor: pokemon.formaTexto, etiqueta: 'Forma'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnatomiaBadge(valor: pokemon.alturaTexto, etiqueta: 'Altura'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnatomiaBadge(valor: pokemon.pesoTexto, etiqueta: 'Peso'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Ingredientes
          Text(
            'Ingredientes · $porciones',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colores.texto,
            ),
          ),
          const SizedBox(height: 8),
          for (final ingrediente in receta.ingredientes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• $ingrediente',
                style: const TextStyle(fontSize: 14, color: Colores.texto),
              ),
            ),
          const SizedBox(height: 24),

          // Preparación
          const Text(
            'Preparación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colores.texto,
            ),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < pasos.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colores.rojo,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pasos[i],
                      style: const TextStyle(fontSize: 14, color: Colores.texto),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}