import '../models/favorito.dart';
import '../models/pokemon.dart';
import '../models/receta.dart';

class FavoritosService {
  static final List<Favorito> _lista = [];

  static List<Favorito> get lista => _lista;

  // ¿Esta receta ya está en favoritos?
  static bool esFavorito(String idReceta) {
    for (final f in _lista) {
      if (f.receta.id == idReceta) return true;
    }
    return false;
  }

  // Si está, la quita; si no está, la agrega
  static void alternar(Receta receta, Pokemon pokemon) {
    if (esFavorito(receta.id)) {
      _lista.removeWhere((f) => f.receta.id == receta.id);
    } else {
      _lista.add(Favorito(receta: receta, pokemon: pokemon));
    }
  }
}