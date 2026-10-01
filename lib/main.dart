import 'package:flutter/material.dart';

import 'data/datasources/lugares_local_datasource.dart';
import 'data/repositories/lugares_repository_impl.dart';
import 'domain/entities/lugar_turistico.dart';
import 'domain/usecases/obtener_lugares.dart';
import 'presentation/viewmodels/detalle_view_model.dart';
import 'presentation/viewmodels/lugares_view_model.dart';
import 'presentation/views/lista_lugares_screen.dart';

void main() {
  final dataSource = LugaresLocalDataSource();
  final repository = LugaresRepositoryImpl(dataSource);
  final obtenerLugares = ObtenerLugares(repository);
  final viewModel = LugaresViewModel(obtenerLugares);

  runApp(
    DescubreDoloresApp(
      viewModel: viewModel,
      crearDetalleViewModel: DetalleViewModel.new,
    ),
  );
}

class DescubreDoloresApp extends StatelessWidget {
  final LugaresViewModel viewModel;
  final DetalleViewModel Function(LugarTuristico) crearDetalleViewModel;

  const DescubreDoloresApp({
    super.key,
    required this.viewModel,
    required this.crearDetalleViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Descubre Dolores Hidalgo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: ListaLugaresScreen(
        viewModel: viewModel,
        crearDetalleViewModel: crearDetalleViewModel,
      ),
    );
  }
}