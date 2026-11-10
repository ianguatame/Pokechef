class Pokemon {
  final String nombre;
  final String imagen;
  final String color;
  final String forma;
  final double alturaM;
  final double pesoKg;

  Pokemon({
    required this.nombre,
    required this.imagen,
    required this.color,
    required this.forma,
    required this.alturaM,
    required this.pesoKg,
  });

  // Porciones según el peso
  int get porciones {
    if (pesoKg < 10) return 1;
    if (pesoKg < 50) return 2;
    if (pesoKg < 100) return 3;
    return 4;
  }

  // Color en español para mostrarlo en pantalla
  String get colorEs {
    const colores = {
      'black': 'Negro',
      'blue': 'Azul',
      'brown': 'Marrón',
      'gray': 'Gris',
      'green': 'Verde',
      'pink': 'Rosa',
      'purple': 'Morado',
      'red': 'Rojo',
      'white': 'Blanco',
      'yellow': 'Amarillo',
    };
    return colores[color] ?? color;
  }

  factory Pokemon.desdeApi(
    Map<String, dynamic> datos,
    Map<String, dynamic> especie,
  ) {
    final String nombre = especie['name'];
    final String imagen =
        datos['sprites']['other']['official-artwork']['front_default'] ??
            datos['sprites']['front_default'] ??
            '';
    final String forma =
        especie['shape'] != null ? especie['shape']['name'] : 'ball';

    return Pokemon(
      nombre: nombre[0].toUpperCase() + nombre.substring(1).replaceAll('-', ' '),
      imagen: imagen,
      color: especie['color']['name'],
      forma: forma,
      alturaM: (datos['height'] as int) / 10,
      pesoKg: (datos['weight'] as int) / 10,
    );
    
  }
  String _formato(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString().replaceAll('.', ',');
  }

  String get alturaTexto => '${_formato(alturaM)} m';
  String get pesoTexto => '${_formato(pesoKg)} kg';
  String get formaTexto => forma[0].toUpperCase() + forma.substring(1);
}