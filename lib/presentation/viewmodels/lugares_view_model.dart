import 'package:flutter/foundation.dart';

import '../../domain/entities/lugar_turistico.dart';
import '../../domain/usecases/obtener_lugares.dart';

class LugaresViewModel extends ChangeNotifier {
  final ObtenerLugares obtenerLugares;

  LugaresViewModel(this.obtenerLugares);

  List<LugarTuristico> _lugares = [];
  List<LugarTuristico> get lugares => List.unmodifiable(_lugares);

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _lugares = await obtenerLugares();
    } catch (e) {
      _lugares = [];
      _error = 'No fue posible cargar los lugares.';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}