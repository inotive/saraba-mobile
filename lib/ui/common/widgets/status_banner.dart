import 'dart:async';

import 'package:flutter/material.dart';

enum StatusBannerType { success, error }

class StatusBanner {
  static OverlayEntry? _currentEntry;
  static Timer? _hideTimer;

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required StatusBannerType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    _hideTimer?.cancel();
    _currentEntry?.remove();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }

    final entry = OverlayEntry(
      builder: (context) =>
          _StatusBannerOverlay(title: title, message: message, type: type),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _hideTimer = Timer(duration, dismiss);
  }

  static void dismiss() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _StatusBannerOverlay extends StatefulWidget {
  final String title;
  final String message;
  final StatusBannerType type;

  const _StatusBannerOverlay({
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  State<_StatusBannerOverlay> createState() => _StatusBannerOverlayState();
}

class _StatusBannerOverlayState extends State<_StatusBannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (widget.type) {
      StatusBannerType.success => const Color(0xFF23C55E),
      StatusBannerType.error => const Color(0xFFC52222),
    };

    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 80),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
