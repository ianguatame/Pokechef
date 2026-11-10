const Map<String, String> formaACategoria = {
  'fish': 'Seafood',
  'tentacles': 'Seafood',
  'wings': 'Chicken',
  'bug-wings': 'Chicken',
  'quadruped': 'Beef',
  'legs': 'Beef',
  'squiggle': 'Pasta',
  'ball': 'Dessert',
  'blob': 'Dessert',
  'arms': 'Pork',
  'upright': 'Lamb',
  'humanoid': 'Lamb',
  'heads': 'Starter',
  'armor': 'Side',
};

// Dada una forma, devuelve la categoría de receta
String categoriaDeForma(String forma) {
  return formaACategoria[forma] ?? 'Dessert';
}

// Dada una categoría, devuelve las formas que le corresponden
List<String> formasDeCategoria(String categoria) {
  final List<String> formas = [];
  formaACategoria.forEach((forma, cat) {
    if (cat == categoria) {
      formas.add(forma);
    }
  });
  return formas;
}

const List<String> categoriasReceta = [
  'Seafood',
  'Chicken',
  'Beef',
  'Pasta',
  'Dessert',
  'Pork',
  'Lamb',
  'Starter',
  'Side',
];