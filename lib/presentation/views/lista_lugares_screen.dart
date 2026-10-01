import 'package:flutter/material.dart';

import '../../domain/entities/lugar_turistico.dart';
import '../viewmodels/detalle_view_model.dart';
import '../viewmodels/lugares_view_model.dart';
import 'detalle_lugar_screen.dart';

class ListaLugaresScreen extends StatefulWidget {
  final LugaresViewModel viewModel;
  final DetalleViewModel Function(LugarTuristico) crearDetalleViewModel;

  const ListaLugaresScreen({
    super.key,
    required this.viewModel,
    required this.crearDetalleViewModel,
  });

  @override
  State<ListaLugaresScreen> createState() => _ListaLugaresScreenState();
}

class _ListaLugaresScreenState extends State<ListaLugaresScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descubre Dolores Hidalgo')),
      body: AnimatedBuilder(
        animation: widget.viewModel,
        builder: (context, _) {
          final viewModel = widget.viewModel;

          if (viewModel.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModel.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: viewModel.cargar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.lugares.isEmpty) {
            return const Center(child: Text('No hay lugares registrados.'));
          }

          return ListView.builder(
            itemCount: viewModel.lugares.length,
            itemBuilder: (context, i) {
              final lugar = viewModel.lugares[i];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    lugar.imagenAsset,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 56,
                      height: 56,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                title: Text(lugar.nombre),
                subtitle: Text(
                  lugar.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetalleLugarScreen(
                        lugar: lugar,
                        crearViewModel: widget.crearDetalleViewModel,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}