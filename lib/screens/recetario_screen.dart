import 'package:flutter/material.dart';
import '../tema.dart';
import '../models/receta.dart';
import '../models/formas.dart';
import '../services/mealdb_service.dart';
import '../widgets/receta_card.dart';

import 'detalle_screen.dart';

class RecetarioScreen extends StatefulWidget {
  const RecetarioScreen({super.key});

  @override
  State<RecetarioScreen> createState() => _RecetarioScreenState();
}

class _RecetarioScreenState extends State<RecetarioScreen> {
  final List<String> _filtros = ['Todas', ...categoriasReceta];
  String _seleccion = 'Todas';
  bool _cargando = false;
  String? _error;
  List<RecetaResumen> _recetas = [];

  @override
  void initState() {
    super.initState();
    _cargarRecetas();
  }

  Future<void> _cargarRecetas() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final servicio = MealDbService();
      final lista = _seleccion == 'Todas'
          ? await servicio.listarTodas()
          : await servicio.listarCategoria(_seleccion);

      if (!mounted) return;
      setState(() {
        _recetas = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar las recetas. Inténtalo de nuevo.';
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _construirFiltros(),
        Expanded(child: _construirContenido()),
      ],
    );
  }

  // Fila horizontal de filtros
  Widget _construirFiltros() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _filtros.length,
        itemBuilder: (context, i) {
          final filtro = _filtros[i];
          final activo = filtro == _seleccion;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filtro),
              selected: activo,
              showCheckmark: false,
              selectedColor: Colores.azul,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: activo ? Colors.white : Colores.texto,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (_) {
                setState(() {
                  _seleccion = filtro;
                });
                _cargarRecetas();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: Colores.rojo));
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_recetas.isEmpty) {
      return const Center(child: Text('No hay recetas en esta categoría.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _recetas.length,
            itemBuilder: (context, i) {
        final receta = _recetas[i];
        return RecetaCard(
          receta: receta,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleScreen(
                  id: receta.id,
                  categoria: receta.categoria,
                ),
              ),
            );
          },
        );
      },
    );
  }
}