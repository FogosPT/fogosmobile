import 'package:flutter/material.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';

const String kIncidentPhotoSignatureKey = 'incident_photo_signature';

class PhotoSignatureSettings extends StatefulWidget {
  const PhotoSignatureSettings({Key? key}) : super(key: key);

  @override
  State<PhotoSignatureSettings> createState() => _PhotoSignatureSettingsState();
}

class _PhotoSignatureSettingsState extends State<PhotoSignatureSettings> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final saved = SharedPreferencesManager.preferences
            .getString(kIncidentPhotoSignatureKey) ??
        '';
    _controller = TextEditingController(text: saved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final value = _controller.text.trim();
    if (value.isEmpty) {
      await SharedPreferencesManager.preferences
          .remove(kIncidentPhotoSignatureKey);
    } else {
      await SharedPreferencesManager.preferences
          .save(kIncidentPhotoSignatureKey, value);
    }
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Definição guardada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assinatura nas fotos de incidente',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Opcional. Se preenchido, o nome aparece no rodapé da foto, '
            'acima dos dados de localização. Mantém curto. Deixa em branco '
            'para não assinar.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLength: 30,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nome a aparecer na foto',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
