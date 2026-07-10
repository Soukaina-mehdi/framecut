import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/section_header.dart';
import '../../../models/effect.dart';

class FiltersTool extends ConsumerStatefulWidget {
  const FiltersTool({super.key});
  @override
  ConsumerState<FiltersTool> createState() => _FiltersToolState();
}

class _FiltersToolState extends ConsumerState<FiltersTool> {
  String _selected = 'none';

  static const _presets = [
    {'label': 'None', 'key': 'none'},
    {'label': 'B&W', 'key': 'bw'},
    {'label': 'Warm', 'key': 'warm'},
    {'label': 'Cool', 'key': 'cool'},
    {'label': 'Vivid', 'key': 'vivid'},
    {'label': 'Cinematic', 'key': 'cinematic'},
    {'label': 'Fade', 'key': 'fade'},
    {'label': 'Matte', 'key': 'matte'},
    {'label': 'Film', 'key': 'film'},
  ];

  void _apply(String key) {
    setState(() => _selected = key);
    if (key == 'none') return;
    ref.read(editorProvider.notifier).addEffect(
          Effect(
            id: const Uuid().v4(),
            typeName: 'filter',
            params: {'preset': key},
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Filters'),
          Text(
            'Selected: ${_presets.firstWhere((p) => p['key'] == _selected)['label']}',
            style: const TextStyle(color: AppTheme.accent, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _presets.map((p) {
                  final isSelected = _selected == p['key'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _apply(p['key']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accent
                              : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accent
                                : const Color(0xFF2A2A2A),
                          ),
                        ),
                        child: Text(
                          p['label']!,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.black : Colors.white,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
