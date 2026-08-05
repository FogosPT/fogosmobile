import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/services/incident_photos_service.dart';
import 'package:intl/intl.dart';

class IncidentPhotosGallery extends StatefulWidget {
  final String fireId;
  final IncidentPhotosService? service;
  final Widget? header;

  const IncidentPhotosGallery({
    Key? key,
    required this.fireId,
    this.service,
    this.header,
  }) : super(key: key);

  @override
  State<IncidentPhotosGallery> createState() => _IncidentPhotosGalleryState();
}

class _IncidentPhotosGalleryState extends State<IncidentPhotosGallery> {
  late final IncidentPhotosService _service;
  final List<IncidentPhoto> _photos = [];
  bool _loading = false;
  bool _loaded = false;
  bool _hasMore = false;
  int _nextPage = 1;
  int _total = 0;
  final Set<String> _failed = {};

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? IncidentPhotosService();
    _fetch();
  }

  Future<void> _fetch() async {
    if (_loading) return;
    setState(() => _loading = true);
    final result = await _service.fetchIncidentPhotos(
      fireId: widget.fireId,
      page: _nextPage,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _loaded = true;
      if (result != null) {
        _photos.addAll(result.photos);
        _total = result.total;
        _hasMore = result.hasMore;
        _nextPage += 1;
      }
    });
  }

  void _openLightbox(int initialIndex) {
    final visible = _photos.where((p) => !_failed.contains(p.id)).toList();
    final idx = visible.indexWhere((p) => p.id == _photos[initialIndex].id);
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _PhotoLightbox(
        photos: visible,
        initialIndex: idx < 0 ? 0 : idx,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const SizedBox.shrink();
    }
    final visiblePhotos =
        _photos.where((p) => !_failed.contains(p.id)).toList();
    if (visiblePhotos.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.header != null) widget.header!,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: visiblePhotos.length,
            itemBuilder: (context, i) {
              final photo = visiblePhotos[i];
              final originalIndex =
                  _photos.indexWhere((p) => p.id == photo.id);
              return GestureDetector(
                onTap: () => _openLightbox(originalIndex),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: photo.url,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 150),
                    placeholder: (_, __) => Container(color: Colors.grey[200]),
                    errorWidget: (_, __, ___) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        setState(() => _failed.add(photo.id));
                      });
                      return Container(color: Colors.grey[200]);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        if (_hasMore && visiblePhotos.length < _total)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: TextButton(
                onPressed: _loading ? null : _fetch,
                child: Text(_loading ? 'A carregar...' : 'Carregar mais'),
              ),
            ),
          ),
      ],
    );
  }
}

class _PhotoLightbox extends StatefulWidget {
  final List<IncidentPhoto> photos;
  final int initialIndex;

  const _PhotoLightbox({
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<_PhotoLightbox> createState() => _PhotoLightboxState();
}

class _PhotoLightboxState extends State<_PhotoLightbox> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    try {
      return DateFormat('dd/MM/yyyy HH:mm').format(dt.toLocal());
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.photos[_index];
    final dateLabel = _formatDate(current.capturedAt);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_index + 1} / ${widget.photos.length}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final p = widget.photos[i];
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: p.url,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 64,
                    ),
                  ),
                ),
              );
            },
          ),
          if (dateLabel.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  dateLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
