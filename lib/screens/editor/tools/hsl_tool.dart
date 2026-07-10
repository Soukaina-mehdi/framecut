import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

const _ranges = ['All', 'Reds', 'Greens', 'Blues', 'Yellows', 'Magentas'];

class HslTool extends ConsumerStatefulWidget {
  const HslTool({super.key});

  @override
  ConsumerState<HslTool> createState() => _HslToolState();
}

class _HslToolState extends ConsumerState<HslTool>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _hue = List.filled(6, 0.0);
  final _sat = List.filled(6, 0.0);
  final _lum = List.filled(6, 0.0);

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _ranges.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _apply(int i) {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'hsl',
      params: {
        'range': _ranges[i].toLowerCase(),
        'hue': _hue[i],
        'sat': _sat[i],
        'lum': _lum[i],
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color(0xFF111111),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const SectionHeader(title: 'HSL / Color Mix'),
          TabBar(
            controller: _tab,
            isScrollable: true,
            indicatorColor: AppTheme.accent,
            labelColor: AppTheme.accent,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            tabs: _ranges.map((r) => Tab(text: r)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: List.generate(_ranges.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      SliderRow(
                        label: 'Hue',
                        value: _hue[i],
                        min: -100,
                        max: 100,
                        onChanged: (v) {
                          setState(() => _hue[i] = v);
                          _apply(i);
                        },
                      ),
                      SliderRow(
                        label: 'Saturation',
                        value: _sat[i],
                        min: -100,
                        max: 100,
                        onChanged: (v) {
                          setState(() => _sat[i] = v);
                          _apply(i);
                        },
                      ),
                      SliderRow(
                        label: 'Luminance',
                        value: _lum[i],
                        min: -100,
                        max: 100,
                        onChanged: (v) {
                          setState(() => _lum[i] = v);
                          _apply(i);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
