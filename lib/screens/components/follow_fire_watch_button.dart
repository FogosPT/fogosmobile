import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/services/live_activity_service.dart';

/// Toggle button for the "follow a fire" experience.
/// - iOS: starts an ActivityKit Live Activity (visible on lock screen,
///   Dynamic Island, and the paired Apple Watch Smart Stack).
/// - Android: starts a foreground service with a persistent ongoing
///   notification that stays in the shade until dismissed.
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Platform.isIOS
                ? 'Não foi possível seguir — verifica as permissões de Live Activity'
                : 'Não foi possível seguir — verifica as permissões de notificação'),
          ));
        }
      }
    }
  }

  IconData get _icon {
    if (Platform.isIOS) {
      return _following ? Icons.watch_off : Icons.watch;
    }
    return _following ? Icons.push_pin : Icons.push_pin_outlined;
  }

  String get _tooltip {
    if (_following) return 'Deixar de seguir';
    return Platform.isIOS ? 'Seguir no relógio' : 'Fixar nas notificações';
  }

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
