# PokeChef


## ¿Qué es PokeChef?

Libro de recetas basado en la **anatomía de los Pokémon**. Cada receta nace de las características físicas de un Pokémon (su forma corporal, color, altura y peso), sin habilidades ni estadísticas de combate.


PokéChef combina dos APIs públicas:

- **[PokeAPI](https://pokeapi.co/)** aporta los datos físicos de un Pokémon: color, forma corporal, altura y peso.
- **[TheMealDB](https://www.themealdb.com/)** aporta las recetas: nombre, foto, ingredientes y preparación.

La app conecta ambas con una regla sencilla:

**Pokémon → forma corporal → categoría de receta → receta**

| Forma del Pokémon (PokeAPI) | Categoría de receta (TheMealDB) |
| fish, tentacles | Seafood |
| wings, bug-wings | Chicken |
| quadruped, legs | Beef |
| squiggle | Pasta |
| ball, blob | Dessert |
| arms | Pork |
| upright, humanoid | Lamb |
| heads | Starter |
| armor | Side |

Además, el peso del Pokémon define el número de porciones de la receta, y su color, altura (en metros) y peso (en kilos) se muestran en la ficha de anatomía.

## Características

- Receta aleatoria con su Pokémon (función de azar).
- Recetario con filtros por categoría y cuadrícula de recetas.
- Detalle de receta con ficha de anatomía, ingredientes y preparación paso a paso.
- Favoritos: guarda y quita recetas con el corazón.
- Navegación con `BottomNavigationBar` entre 3 pestañas y una pantalla de detalle (4 pantallas).
- Widgets personalizados: `RecetaCard` y `AnatomiaBadge`.
- Imágenes desde internet (`Image.network`) y desde assets (`Image.asset`).

## Tecnologías

- Flutter y Dart
- Paquete [`http`](https://pub.dev/packages/http) para consumir las APIs
- Figma para el diseño de la interfaz

## Diseño y documentación

- Diseño en Figma: `https://www.figma.com/make/TyCfSR2sYvqseBzxY8m43u/Pok%C3%A9Chef-Recetas-Pok%C3%A9mon?p=f&t=wZ0ZypDy9GDsspBE-0&fullscreen=1`
- Documento PDF (descripción, target, casos de uso, historias de usuario y diseño visual): `https://academiausbbogedu-my.sharepoint.com/:w:/g/personal/hgcastanob_academia_usbbog_edu_co/IQA6OfUl7NrLR4VIDpt-Ag4uAY8hRPmvYApUztNA8J7ATUM?rtime=_agaI2ZA30g`
- Video de sustentación: `https://www.youtube.com/watch?v=BubSlEjAIRI`

## Capturas de pantalla

| Inicio | Recetario | | Favoritos |
| ![Inicio](capturas/inicio.jpg) | ![Recetario](capturas/recetario.jpg) | ![Favoritos](capturas/favoritos.jpg) |

## Estructura del proyecto

```
lib/
├── main.dart                  # Punto de entrada, tema y navegación
├── tema.dart                  # Colores de la app
├── models/
│   ├── pokemon.dart           # Datos físicos del Pokémon
│   ├── receta.dart            # Receta y receta resumida
│   ├── favorito.dart          # Receta + Pokémon guardados
│   └── formas.dart            # Tabla forma -> categoría
├── services/
│   ├── pokeapi_service.dart   # Consultas a PokeAPI
│   ├── mealdb_service.dart    # Consultas a TheMealDB
│   └── favoritos_service.dart # Lista de favoritos en memoria
├── screens/
│   ├── inicio_screen.dart
│   ├── recetario_screen.dart
│   ├── detalle_screen.dart
│   └── favoritos_screen.dart
└── widgets/
    ├── receta_card.dart
    └── anatomia_badge.dart
assets/
└── images/
    └── logo.png
```

## Instalación y ejecución

### Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Visual Studio Code con las extensiones de Flutter y Dart
- Conexión a internet (la app consulta las APIs en línea)

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/ianguatame/Pokechef.git
cd <nombre-del-repositorio>

# 2. Instalar las dependencias
flutter pub get

# 3. Ejecutar la app (Chrome, emulador o dispositivo conectado)
flutter run
```

Para ejecutarla en el navegador: `flutter run -d chrome`.

## Manual de uso

1. **Inicio:** al abrir la app aparece la "Receta del día", con la foto del plato y el Pokémon en que se basa. Pulsa **Receta aleatoria** para obtener otra. Toca la tarjeta para ver la receta completa.
2. **Recetario:** elige una categoría en la fila de filtros (o "Todas") y navega por la cuadrícula de recetas. Toca una receta para abrir su detalle.
3. **Detalle de receta:** revisa la ficha de anatomía del Pokémon (color, forma, altura y peso), los ingredientes y los pasos de preparación. Toca el **corazón** para guardarla en favoritos.
4. **Favoritos:** consulta tus recetas guardadas, ábrelas o quítalas con el corazón rojo. Los favoritos se guardan mientras la app está abierta.

## Créditos y aviso

- Datos de Pokémon: [PokeAPI](https://pokeapi.co/).
- Recetas e imágenes de platos: [TheMealDB](https://www.themealdb.com/).

## Autor

`[Ian Guatame, Miguel Villanueva, Gustavo Pacheco, Hanna Castaño]` 
