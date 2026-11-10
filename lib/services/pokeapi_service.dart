import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../models/formas.dart';

class PokeApiService {
  final String _base = 'https://pokeapi.co/api/v2';
  final Random _random = Random();

  Future<Map<String, dynamic>> _pedir(String url) async {
    final respuesta = await http.get(Uri.parse(url));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Error al conectar con PokeAPI.');
    }
  }

  // Pokémon por número (datos físicos + color y forma)
  Future<Pokemon> pokemonPorId(int id) async {
    final datos = await _pedir('$_base/pokemon/$id');
    final especie = await _pedir('$_base/pokemon-species/$id');
    return Pokemon.desdeApi(datos, especie);
  }

  // Un Pokémon al azar
  Future<Pokemon> pokemonAleatorio() {
    final id = _random.nextInt(1025) + 1;
    return pokemonPorId(id);
  }

  // Un Pokémon al azar cuya forma corresponda a una categoría de receta
  Future<Pokemon> pokemonDeCategoria(String categoria) async {
    final formas = formasDeCategoria(categoria);
    if (formas.isEmpty) {
      return pokemonAleatorio();
    }
    final forma = formas[_random.nextInt(formas.length)];
    final datos = await _pedir('$_base/pokemon-shape/$forma');
    final List<dynamic> lista = datos['pokemon_species'];
    final elegido = lista[_random.nextInt(lista.length)];
    final partes = (elegido['url'] as String).split('/');
    final id = int.parse(partes[partes.length - 2]);
    return pokemonPorId(id);
  }
}