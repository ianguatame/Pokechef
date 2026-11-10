import 'package:flutter/material.dart';
import '../tema.dart';
import '../services/favoritos_service.dart';
import 'detalle_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosService.lista;

    // Mensaje cuando todavía no hay favoritos
    if (favoritos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 64, color: Colores.gris),
              SizedBox(height: 12),
              Text(
                'Aún no tienes recetas favoritas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colores.texto,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Toca el corazón en el detalle de una receta para guardarla.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colores.gris),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoritos.length,
      itemBuilder: (context, i) {
        final f = favoritos[i];
        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFDDE1EA)),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                f.receta.imagen,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              f.receta.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colores.texto,
              ),
            ),
            subtitle: Text(
              '${f.receta.categoria} · ${f.pokemon.nombre}',
              style: const TextStyle(color: Colores.gris),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colores.rojo),
              onPressed: () {
                setState(() {
                  FavoritosService.alternar(f.receta, f.pokemon);
                });
              },
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleScreen(
                    id: f.receta.id,
                    categoria: f.receta.categoria,
                    pokemon: f.pokemon,
                  ),
                ),
              );
              // Al volver, se refresca por si quitó el favorito dentro del detalle
              if (!mounted) return;
              setState(() {});
            },
          ),
        );
      },
    );
  }
}