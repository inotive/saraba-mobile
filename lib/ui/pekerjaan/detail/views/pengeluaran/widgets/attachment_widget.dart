import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_attachment_item.dart';

class AttachmentThumbnail extends StatelessWidget {
  final MaterialAttachmentItem image;
  final List<MaterialAttachmentItem>? galleryImages;
  final int initialIndex;
  final double width;
  final double height;

  const AttachmentThumbnail({
    super.key,
    required this.image,
    this.galleryImages,
    this.initialIndex = 0,
    this.width = 92,
    this.height = 92,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _AttachmentThumbnailContent(
          image: image,
          width: width,
          height: height,
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _AttachmentPreviewPage(
          images: galleryImages ?? [image],
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _AttachmentThumbnailContent extends StatelessWidget {
  final MaterialAttachmentItem image;
  final double width;
  final double height;

  const _AttachmentThumbnailContent({
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (_isPdfAttachment(image.path)) {
      return _AttachmentDocumentTile(
        width: width,
        height: height,
        extensionLabel: 'PDF',
      );
    }

    if (_isSvgAttachment(image.path)) {
      if (image.isFile) {
        return SvgPicture.file(
          File(image.path),
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholderBuilder: (_) =>
              _AttachmentLoadingTile(width: width, height: height),
        );
      }

      if (image.isNetwork) {
        return SvgPicture.network(
          image.path,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholderBuilder: (_) =>
              _AttachmentLoadingTile(width: width, height: height),
        );
      }

      return SvgPicture.asset(
        image.path,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    if (image.isFile) {
      return Image.file(
        File(image.path),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    if (image.isNetwork) {
      return Image.network(
        image.path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _AttachmentLoadingTile(width: width, height: height);
        },
        errorBuilder: (_, _, _) =>
            _AttachmentErrorTile(width: width, height: height),
      );
    }

    return Image.asset(
      image.path,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}

class _AttachmentPreviewPage extends StatefulWidget {
  final List<MaterialAttachmentItem> images;
  final int initialIndex;

  const _AttachmentPreviewPage({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_AttachmentPreviewPage> createState() => _AttachmentPreviewPageState();
}

class _AttachmentPreviewPageState extends State<_AttachmentPreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: widget.images.length > 1
            ? Text('${_currentIndex + 1}/${widget.images.length}')
            : null,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(child: _buildPreviewContent(widget.images[index]));
        },
      ),
    );
  }

  Widget _buildPreviewContent(MaterialAttachmentItem image) {
    if (_isPdfAttachment(image.path)) {
      return _buildPdfPreview(image);
    }

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4,
      child: _buildImagePreview(image),
    );
  }

  Widget _buildImagePreview(MaterialAttachmentItem image) {
    if (_isSvgAttachment(image.path)) {
      if (image.isFile) {
        return SvgPicture.file(
          File(image.path),
          fit: BoxFit.contain,
          placeholderBuilder: (_) =>
              const CircularProgressIndicator(color: Colors.white),
        );
      }

      if (image.isNetwork) {
        return SvgPicture.network(
          image.path,
          fit: BoxFit.contain,
          placeholderBuilder: (_) =>
              const CircularProgressIndicator(color: Colors.white),
        );
      }

      return SvgPicture.asset(image.path, fit: BoxFit.contain);
    }

    if (image.isFile) {
      return Image.file(File(image.path), fit: BoxFit.contain);
    }

    if (image.isNetwork) {
      return Image.network(
        image.path,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        errorBuilder: (_, _, _) => const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white70,
          size: 48,
        ),
      );
    }

    return Image.asset(image.path, fit: BoxFit.contain);
  }

  Widget _buildPdfPreview(MaterialAttachmentItem image) {
    if (image.isFile) {
      return PdfViewer.file(
        image.path,
        params: const PdfViewerParams(backgroundColor: Colors.black),
      );
    }

    if (image.isNetwork) {
      return PdfViewer.uri(
        Uri.parse(image.path),
        params: const PdfViewerParams(backgroundColor: Colors.black),
      );
    }

    return Center(
      child: Text(
        _extractFileName(image.path),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AttachmentLoadingTile extends StatelessWidget {
  final double width;
  final double height;

  const _AttachmentLoadingTile({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF1F3F5),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _AttachmentErrorTile extends StatelessWidget {
  final double width;
  final double height;

  const _AttachmentErrorTile({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF1F3F5),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFF9AA0A6),
      ),
    );
  }
}

class _AttachmentDocumentTile extends StatelessWidget {
  final double width;
  final double height;
  final String extensionLabel;

  const _AttachmentDocumentTile({
    required this.width,
    required this.height,
    required this.extensionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: Color(0xFFD14343),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            extensionLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}

bool _isPdfAttachment(String path) => path.toLowerCase().endsWith('.pdf');

bool _isSvgAttachment(String path) => path.toLowerCase().endsWith('.svg');

String _extractFileName(String path) {
  final sanitized = path.split('?').first;
  final segments = sanitized.split('/');
  return segments.isEmpty ? path : segments.last;
}
