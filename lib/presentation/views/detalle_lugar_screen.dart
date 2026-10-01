import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/lugar_turistico.dart';
import '../viewmodels/detalle_view_model.dart';

class DetalleLugarScreen extends StatefulWidget {
  final LugarTuristico lugar;
  final DetalleViewModel Function(LugarTuristico) crearViewModel;

  const DetalleLugarScreen({
    super.key,
    required this.lugar,
    required this.crearViewModel,
  });

  @override
  State<DetalleLugarScreen> createState() => _DetalleLugarScreenState();
}

class _DetalleLugarScreenState extends State<DetalleLugarScreen> {
  late final DetalleViewModel _viewModel;
  VideoPlayerController? _videoController;
  String? _errorVideo;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.crearViewModel(widget.lugar);

    final video = widget.lugar.videoAsset;
    if (video != null) {
      _videoController = VideoPlayerController.asset(video);
      _inicializarVideo(_videoController!);
    }
  }

  Future<void> _inicializarVideo(VideoPlayerController controlador) async {
    try {
      await controlador.initialize();
    } catch (e) {
      await controlador.dispose();
      _videoController = null;
      _errorVideo = 'No fue posible cargar el video.';
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _alternarVideo() async {
    final controlador = _videoController;
    if (controlador == null) return;
    if (controlador.value.isPlaying) {
      await controlador.pause();
    } else {
      await controlador.play();
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controlador = _videoController;

    return Scaffold(
      appBar: AppBar(title: Text(widget.lugar.nombre)),
      body: ListView(
        children: [
          Image.asset(
            widget.lugar.imagenAsset,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 220,
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported, size: 48),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.lugar.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          AnimatedBuilder(
            animation: _viewModel,
            builder: (context, _) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: _viewModel.alternarAudio,
                    icon: Icon(
                      _viewModel.reproduciendo ? Icons.pause : Icons.headphones,
                    ),
                    label: Text(
                      _viewModel.reproduciendo
                          ? 'Pausar audioguía'
                          : 'Escuchar audioguía',
                    ),
                  ),
                ),
                if (_viewModel.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: Text(
                      _viewModel.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_errorVideo != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _errorVideo!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (controlador != null && controlador.value.isInitialized)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: controlador.value.aspectRatio,
                    child: VideoPlayer(controlador),
                  ),
                  IconButton(
                    icon: Icon(
                      controlador.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                    ),
                    iconSize: 48,
                    onPressed: _alternarVideo,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}