import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';
import '../../../models/text_overlay.dart';

class TextTool extends ConsumerStatefulWidget {
  const TextTool({super.key});
  @override
  ConsumerState<TextTool> createState() => _TextToolState();
}

class _TextToolState extends ConsumerState<TextTool> {
  final _controller = TextEditingController();
  double _fontSize = 32.0;
  Color _color = Colors.white;
  String _animation = 'None';

  static const _colors = [
    Colors.white,
    Colors.yellow,
    Colors.red,
    Colors.cyan,
    Colors.greenAccent,
    Colors.orange,
  ];

  static const _animations = [
    'None', 'Fade In', 'Slide In', 'Typewriter', 'Bounce',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(editorProvider.notifier).addTextOverlay(
          TextOverlay(
            id: const Uuid().v4(),
            text: text,
            fontSize: _fontSize,
            colorHex:
                '#${_color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
            animationName: _animation == 'None' ? null : _animation,
          ),
        );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Text'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type something…',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Color(0xFF2A2A2A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Color(0xFF2A2A2A)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _addText,
                child: const Text('Add', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderRow(
            label: 'Size',
            value: _fontSize,
            min: 12,
            max: 96,
            onChanged: (v) => setState(() => _fontSize = v),
          ),
          Row(
            children: [
              const Text('Color',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(width: 10),
              ..._colors.map((c) => GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == c
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  )),
              const Spacer(),
              DropdownButton<String>(
                value: _animation,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                underline: const SizedBox.shrink(),
                items: _animations
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (v) => setState(() => _animation = v!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
