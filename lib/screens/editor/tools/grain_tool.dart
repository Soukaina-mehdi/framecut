import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

class GrainTool extends ConsumerStatefulWidget {
  const GrainTool({super.key});

  @override
  ConsumerState<GrainTool> createState() => _GrainToolState();
}

class _GrainToolState extends ConsumerState<GrainTool> {
  double _amount = 0.3;
  double _size = 0.5;
  bool _colorGrain = false;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'grain',
      params: {
        'amount': _amount,
        'size': _size,
        'color': _colorGrain,
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Film Grain'),
          SliderRow(
            label: 'Amount',
            value: _amount,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _amount = v);
              _apply();
            },
          ),
          SliderRow(
            label: 'Size',
            value: _size,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _size = v);
              _apply();
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Grain Type',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              _TypeToggle(
                isColor: _colorGrain,
                onChanged: (v) {
                  setState(() => _colorGrain = v);
                  _apply();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Type: ${_colorGrain ? 'Color' : 'Monochrome'} grain',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final bool isColor;
  final ValueChanged<bool> onChanged;
  const _TypeToggle({required this.isColor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Seg(label: 'Mono', active: !isColor, onTap: () => onChanged(false)),
          _Seg(label: 'Color', active: isColor, onTap: () => onChanged(true)),
        ],
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Seg({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white54,
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
