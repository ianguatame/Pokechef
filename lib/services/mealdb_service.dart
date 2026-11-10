import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/receta.dart';
import '../models/formas.dart';

class MealDbService {
  final String _base = 'https://www.themealdb.com/api/json/v1/1';
  final Random _random = Random();

  Future<Map<String, dynamic>> _pedir(String url) async {
    final respuesta = await http.get(Uri.parse(url));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Error al conectar con TheMealDB.');
    }
  }

  // Lista resumida de recetas de una categoría (id, nombre y foto)
  Future<List<dynamic>> recetasDeCategoria(String categoria) async {
    final datos = await _pedir('$_base/filter.php?c=$categoria');
    return datos['meals'];
  }

  // Receta completa por id
  Future<Receta> recetaPorId(String id) async {
    final datos = await _pedir('$_base/lookup.php?i=$id');
    return Receta.desdeApi(datos['meals'][0]);
  }

  // Una receta al azar de una categoría
  Future<Receta> recetaAleatoriaDeCategoria(String categoria) async {
    final lista = await recetasDeCategoria(categoria);
    final elegida = lista[_random.nextInt(lista.length)];
    return recetaPorId(elegida['idMeal']);
  }

    // Recetas resumidas de una categoría
  Future<List<RecetaResumen>> listarCategoria(String categoria) async {
    final lista = await recetasDeCategoria(categoria);
    final List<RecetaResumen> resultado = [];
    for (final r in lista) {
      resultado.add(RecetaResumen(
        id: r['idMeal'],
        nombre: r['strMeal'],
        imagen: r['strMealThumb'] ?? '',
        categoria: categoria,
      ));
    }
    return resultado;
  }

  // Recetas de todas las categorías (las 9 consultas se hacen al mismo tiempo)
  Future<List<RecetaResumen>> listarTodas() async {
    final resultados = await Future.wait(
      categoriasReceta.map((c) => listarCategoria(c)),
    );
    final List<RecetaResumen> todas = [];
    for (final lista in resultados) {
      todas.addAll(lista);
    }
    return todas;
  }
}