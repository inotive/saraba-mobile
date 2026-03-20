import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final String title;

  const CameraPage({super.key, required this.camera, this.title = 'Clock In'});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  bool _isReady = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();

    if (!mounted) return;

    setState(() {
      _isReady = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_isReady || _isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final XFile file = await _controller.takePicture();

      if (!mounted) return;
      Navigator.pop(context, file);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isTakingPicture = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengambil foto')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildCameraPreview(),
          Container(color: Colors.black.withValues(alpha: 0.20)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const _FaceGuideOverlay(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: Row(
                    children: [
                      const SizedBox(width: 44),
                      const Spacer(),
                      GestureDetector(
                        onTap: _isTakingPicture ? null : _takePicture,
                        child: Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: _isTakingPicture
                                  ? const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    final previewSize = _controller.value.previewSize;

    if (previewSize == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: previewSize.height,
          height: previewSize.width,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }
}

class _FaceGuideOverlay extends StatelessWidget {
  const _FaceGuideOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 240,
          height: 320,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(160),
          ),
        ),
      ),
    );
  }
}
