import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/lugar_turistico.dart';

class DetalleViewModel extends ChangeNotifier {
  final LugarTuristico lugar;
  final AudioPlayer _reproductor;

  DetalleViewModel(this.lugar, {AudioPlayer? reproductor})
      : _reproductor = reproductor ?? AudioPlayer() {
    _reproductor.setReleaseMode(ReleaseMode.stop);
    _reproductor.onPlayerComplete.listen((_) {
      _reproduciendo = false;
      notifyListeners();
    });
  }

  bool _reproduciendo = false;
  bool get reproduciendo => _reproduciendo;

  String? _error;
  String? get error => _error;

  Future<void> alternarAudio() async {
    try {
      if (_reproductor.state == PlayerState.playing) {
        await _reproductor.pause();
        _reproduciendo = false;
      } else {
        await _reproductor.play(AssetSource(lugar.audioAsset));
        _reproduciendo = true;
      }
      _error = null;
    } catch (e) {
      _reproduciendo = false;
      _error = 'No fue posible reproducir el audio.';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _reproductor.dispose();
    super.dispose();
  }
}