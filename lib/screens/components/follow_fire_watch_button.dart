import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/services/live_activity_service.dart';

/// Toggle button to "follow" a fire — pins it for continuous updates
/// wherever the OS surfaces persistent activity:
/// - iOS: Live Activity on lock screen, Dynamic Island, and (bonus) the
///   paired Apple Watch Smart Stack when available.
/// - Android: persistent ongoing notification in the shade.
class FollowFireWatchButton extends StatefulWidget {
  final Fire fire;

  const FollowFireWatchButton({Key? key, required this.fire}) : super(key: key);

  @override
  State<FollowFireWatchButton> createState() => _FollowFireWatchButtonState();
}

class _FollowFireWatchButtonState extends State<FollowFireWatchButton> {
  bool _following = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshState();
  }

  Future<void> _refreshState() async {
    final active = await LiveActivityService.isActive(widget.fire.id);
    if (mounted) setState(() => _following = active);
  }

  Future<void> _toggle() async {
    setState(() => _busy = true);
    if (_following) {
      await LiveActivityService.stop(widget.fire.id);
      if (mounted) setState(() { _following = false; _busy = false; });
    } else {
      final ok = await LiveActivityService.start(widget.fire);
      if (mounted) {
        setState(() { _following = ok; _busy = false; });
        if (!ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Não foi possível seguir — verifica as permissões nas Definições'),
          ));
        }
      }
    }
  }

  IconData get _icon => _following ? Icons.push_pin : Icons.push_pin_outlined;

  String get _tooltip => _following ? 'Deixar de seguir' : 'Seguir este incêndio';

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS && !Platform.isAndroid) return const SizedBox.shrink();
    return IconButton(
      icon: _busy
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(_icon),
      tooltip: _tooltip,
      onPressed: _busy ? null : _toggle,
    );
  }
}
