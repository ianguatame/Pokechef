class Receta {
  final String id;
  final String nombre;
  final String imagen;
  final String categoria;
  final String instrucciones;
  final List<String> ingredientes;

  Receta({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.categoria,
    required this.instrucciones,
    required this.ingredientes,
  });

  factory Receta.desdeApi(Map<String, dynamic> datos) {
    final List<String> lista = [];
    for (int i = 1; i <= 20; i++) {
      final ingrediente = (datos['strIngredient$i'] ?? '').toString().trim();
      final medida = (datos['strMeasure$i'] ?? '').toString().trim();
      if (ingrediente.isNotEmpty) {
        lista.add(medida.isEmpty ? ingrediente : '$ingrediente · $medida');
      }
    }

    return Receta(
      id: datos['idMeal'],
      nombre: datos['strMeal'],
      imagen: datos['strMealThumb'] ?? '',
      categoria: datos['strCategory'] ?? '',
      instrucciones: datos['strInstructions'] ?? '',
      ingredientes: lista,
    );
  }
}

class RecetaResumen {
  final String id;
  final String nombre;
  final String imagen;
  final String categoria;

  RecetaResumen({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.categoria,
  });
}