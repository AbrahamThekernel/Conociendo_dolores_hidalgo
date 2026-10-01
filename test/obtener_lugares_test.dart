import 'package:clean_architecure/presentation/viewmodels/lugares_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecure/domain/entities/lugar_turistico.dart';
import 'package:clean_architecure/domain/repositories/lugares_repository.dart';

class FakeLugaresRepository implements LugaresRepository {
  @override
  Future<List<LugarTuristico>> obtenerTodos() async => const [
        LugarTuristico(
          id: '1',
          nombre: 'Lugar de prueba',
          descripcion: 'Descripcion de prueba',
          imagenAsset: 'x.jpg',
          audioAsset: 'x.mp3',
        ),
      ];

  @override
  Future<LugarTuristico?> obtenerPorId(String id) async => null;
}

void main() {
  test('ObtenerLugares regresa la lista que entrega el repositorio', () async {
    final usecase = ObtenerLugares(FakeLugaresRepository());
    final resultado = await usecase();

    expect(resultado.length, 1);
    expect(resultado.first.nombre, 'Lugar de prueba');
  });
}
