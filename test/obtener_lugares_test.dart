import 'package:clean_architecure/domain/entities/lugar_turistico.dart';
import 'package:clean_architecure/domain/repositories/lugares_repository.dart';
import 'package:clean_architecure/domain/usecases/obtener_lugares.dart';
import 'package:clean_architecure/presentation/viewmodels/lugares_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLugaresRepository implements LugaresRepository {
  @override
  Future<List<LugarTuristico>> obtenerTodos() async => const [
        LugarTuristico(
          id: '1',
          nombre: 'Lugar de prueba',
          descripcion: 'Descripción de prueba',
          imagenAsset: 'x.jpg',
          audioAsset: 'x.mp3',
        ),
      ];
}

class RepositorioConError implements LugaresRepository {
  @override
  Future<List<LugarTuristico>> obtenerTodos() async {
    throw Exception('fallo simulado');
  }
}

void main() {
  test('ObtenerLugares regresa la lista que entrega el repositorio', () async {
    final usecase = ObtenerLugares(FakeLugaresRepository());
    final resultado = await usecase();

    expect(resultado.length, 1);
    expect(resultado.first.nombre, 'Lugar de prueba');
  });

  test('LugaresViewModel carga los lugares y limpia el estado de carga', () async {
    final viewModel = LugaresViewModel(ObtenerLugares(FakeLugaresRepository()));

    await viewModel.cargar();

    expect(viewModel.cargando, isFalse);
    expect(viewModel.error, isNull);
    expect(viewModel.lugares.length, 1);
  });

  test('LugaresViewModel expone el error cuando el repositorio falla', () async {
    final viewModel = LugaresViewModel(ObtenerLugares(RepositorioConError()));

    await viewModel.cargar();

    expect(viewModel.cargando, isFalse);
    expect(viewModel.error, isNotNull);
    expect(viewModel.lugares, isEmpty);
  });
}