import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fogosmobile/screens/widgets/plane_annotation_manager.dart';
import 'package:fogosmobile/services/fcm_debug_bridge.dart';
import 'package:fogosmobile/services/push_registry.dart';
import 'package:intl/intl.dart';

/// Read-only panel that surfaces every signal we track for the push pipeline
/// (authorisation state, FCM/APNs tokens, subscribed topics, last message
/// received). Users forward the copy-to-clipboard dump to support when
/// notifications stop working.
class NotificationDiagnostics extends StatefulWidget {
  const NotificationDiagnostics({Key? key}) : super(key: key);

  @override
  State<NotificationDiagnostics> createState() =>
      _NotificationDiagnosticsState();
}

class _NotificationDiagnosticsState extends State<NotificationDiagnostics> {
  PushDiagnostics? _diag;
  bool _loading = true;
  String? _authFromOs;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    final diag = await PushRegistry.diagnostics();
    String? authFromOs;
    try {
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      authFromOs = settings.authorizationStatus.name;
      await PushRegistry.recordAuthStatus(authFromOs);
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _diag = diag;
      _authFromOs = authFromOs;
      _loading = false;
    });
  }

  String _fmtTs(int? ms) {
    if (ms == null) return '—';
    final dt = DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  String _shortToken(String? token) {
    if (token == null || token.isEmpty) return '—';
    if (token.length <= 16) return token;
    return '${token.substring(0, 8)}…${token.substring(token.length - 8)}';
  }

  Future<void> _debugNative() async {
    final result = await FcmDebugBridge.fetchToken();
    if (!mounted) return;
    final buf = StringBuffer('Debug FCM nativo\n');
    if (result == null || result.isEmpty) {
      buf.writeln('(sem resposta)');
    } else {
      result.forEach((k, v) => buf.writeln('$k: $v'));
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Debug FCM (nativo)'),
        content: SingleChildScrollView(
          child: SelectableText(
            buf.toString(),
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: buf.toString()));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Copiar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _forceRefresh() async {
    setState(() => _loading = true);
    final result = await PushRegistry.forceRefreshToken();
    if (!mounted) return;
    await _reload();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.success
            ? 'Novo token FCM obtido'
            : 'Falhou: ${result.getError ?? "sem detalhes"}'),
        duration: const Duration(seconds: 8),
      ),
    );
  }

  Future<void> _copyAll() async {
    final d = _diag;
    if (d == null) return;
    final buf = StringBuffer()
      ..writeln('Fogos.pt — Diagnóstico de notificações')
      ..writeln('Plataforma: ${Platform.operatingSystem}')
      ..writeln('Autorização: ${_authFromOs ?? d.authStatus ?? "?"}')
      ..writeln('FCM token: ${d.fcmToken ?? "—"}')
      ..writeln('APNs token: ${d.apnsToken ?? "—"}')
      ..writeln('Último token conhecido: ${d.lastKnownToken ?? "—"}')
      ..writeln('Última rotação de token: ${_fmtTs(d.lastTokenRefreshMs)}')
      ..writeln('Última mensagem recebida: ${_fmtTs(d.lastMessageMs)}')
      ..writeln('Último erro FCM: ${d.lastFcmError ?? "—"}')
      ..writeln('Tópicos ativos (${d.topics.length}):');
    for (final t in d.topics) {
      buf.writeln('  - $t');
    }
    await Clipboard.setData(ClipboardData(text: buf.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diagnóstico copiado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _diag == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final d = _diag!;
    final auth = _authFromOs ?? d.authStatus;
    final isProvisional = auth == 'provisional';
    final isDenied = auth == 'denied' || auth == 'notDetermined';
    final iosFcmMissing = Platform.isIOS &&
        (d.apnsToken?.isNotEmpty ?? false) &&
        (d.fcmToken?.isEmpty ?? true);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isProvisional) _banner(
            color: const Color(0xffFFF3D6),
            icon: Icons.volume_off,
            iconColor: const Color(0xffB4802E),
            title: 'Notificações em modo silencioso',
            body:
                'Autorizaste em modo provisório: as notificações chegam mas ficam '
                'só na Central de Notificações, sem som nem banner. Abre '
                'Definições → Fogos.pt → Notificações e permite totalmente.',
          ),
          if (isDenied) _banner(
            color: const Color(0xffFFE0DE),
            icon: Icons.notifications_off,
            iconColor: const Color(0xffAD1F1F),
            title: 'Notificações desativadas',
            body:
                'Não deste permissão ao Fogos.pt para enviar notificações. '
                'Abre Definições → Fogos.pt → Notificações e ativa.',
          ),
          if (iosFcmMissing) _banner(
            color: const Color(0xffFFE0DE),
            icon: Icons.link_off,
            iconColor: const Color(0xffAD1F1F),
            title: 'Sem token FCM',
            body:
                'O iOS entregou o token APNs mas o Firebase ainda não '
                'devolveu o token FCM — sem isto não recebes '
                'notificações. Toca em "Debug FCM (nativo)" abaixo e '
                'copia o resultado para o suporte. Evita carregar em '
                '"Forçar novo token FCM" várias vezes seguidas — cada '
                'toque pode ativar o rate-limit do Firebase e bloquear '
                'a derivação do token durante uma hora.',
          ),
          if (d.lastFcmError != null)
            _banner(
              color: const Color(0xffFFF3D6),
              icon: Icons.error_outline,
              iconColor: const Color(0xffB4802E),
              title: 'Último erro FCM',
              body: d.lastFcmError!,
            ),
          _row('Estado', auth ?? '—'),
          _row('Última mensagem recebida', _fmtTs(d.lastMessageMs)),
          _row('Última rotação FCM', _fmtTs(d.lastTokenRefreshMs)),
          _row('FCM token', _shortToken(d.fcmToken)),
          if (Platform.isIOS) _row('APNs token', _shortToken(d.apnsToken)),
          _row('Tópicos ativos', d.topics.length.toString()),
          const SizedBox(height: 8),
          _row('Última sync aviões', _fmtTs(PlaneSyncReport.lastAttemptMs)),
          _row('Aviões (recebidos / c/ posição / no mapa)',
              '${PlaneSyncReport.totalPlanes ?? "—"} / ${PlaneSyncReport.withPositions ?? "—"} / ${PlaneSyncReport.placedAnnotations ?? "—"}'),
          if (PlaneSyncReport.lastError != null)
            _row('Erro aviões', PlaneSyncReport.lastError!),
          const SizedBox(height: 12),
          if (d.topics.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tópicos', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ...d.topics.take(30).map(
                      (t) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(t, style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                    if (d.topics.length > 30)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${d.topics.length - 30} mais',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Atualizar'),
                  onPressed: _reload,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                  onPressed: _copyAll,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.sync_problem),
            label: const Text('Forçar novo token FCM'),
            onPressed: _forceRefresh,
          ),
          if (Platform.isIOS) ...[
            const SizedBox(height: 4),
            OutlinedButton.icon(
              icon: const Icon(Icons.bug_report),
              label: const Text('Debug FCM (nativo)'),
              onPressed: _debugNative,
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner({
    required Color color,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: iconColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
