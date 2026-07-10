import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../models/clip.dart';
import '../../../models/audio_track.dart';
import '../../../models/text_overlay.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';

class LowerThirdsTool extends ConsumerStatefulWidget {
  const LowerThirdsTool({super.key});
  @override
  ConsumerState<LowerThirdsTool> createState() => _LowerThirdsToolState();
}

class _LowerThirdsToolState extends ConsumerState<LowerThirdsTool> {
  String _style = 'minimal';
  final _titleCtrl = TextEditingController(text: 'John Doe');
  final _subtitleCtrl = TextEditingController(text: 'CEO, Company');
  String _position = 'bottom';

  static const _styles = [
    ('Minimal', 'minimal'),
    ('Bold', 'bold'),
    ('Stripe', 'stripe'),
    ('Line', 'line'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.subtitles, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Lower Thirds', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          Row(children: _styles.map((s) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _style = s.$2),
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _style == s.$2 ? AppTheme.accentColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
                  border: Border.all(color: _style == s.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(s.$1, style: TextStyle(color: _style == s.$2 ? Colors.white : Colors.white54, fontSize: 10), textAlign: TextAlign.center),
              ),
            ),
          )).toList()),
          const SizedBox(height: 8),
          _inputField('Title', _titleCtrl),
          const SizedBox(height: 6),
          _inputField('Subtitle', _subtitleCtrl),
          const SizedBox(height: 6),
          Row(children: [
            const Text('Position:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            _posBtn('Bottom', 'bottom'),
            const SizedBox(width: 6),
            _posBtn('Middle', 'middle'),
          ]),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () {
                final yPos = _position == 'bottom' ? 0.8 : 0.5;
                ref.read(editorProvider.notifier).addTextOverlay(TextOverlay(
                  id: const Uuid().v4(),
                  text: '${_titleCtrl.text}\n${_subtitleCtrl.text}',
                  animation: 'slideIn',
                  durationSec: 4.0,
                  x: 0.1,
                  y: yPos,
                  style: _style,
                ));
              },
              child: const Text('Add Lower Third'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl) => TextField(
    controller: ctrl,
    style: const TextStyle(color: Colors.white, fontSize: 12),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 11),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentColor), borderRadius: BorderRadius.circular(4)),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      isDense: true,
    ),
  );

  Widget _posBtn(String label, String value) => GestureDetector(
    onTap: () => setState(() => _position = value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _position == value ? AppTheme.accentColor : const Color(0xFF1A1A1A),
        border: Border.all(color: _position == value ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: _position == value ? Colors.white : Colors.white60, fontSize: 11)),
    ),
  );
}
