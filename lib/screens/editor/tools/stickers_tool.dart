import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/section_header.dart';
import '../../../models/text_overlay.dart';

class StickersTool extends ConsumerStatefulWidget {
  const StickersTool({super.key});
  @override
  ConsumerState<StickersTool> createState() => _StickersToolState();
}

class _StickersToolState extends ConsumerState<StickersTool> {
  String _search = '';
  final _searchController = TextEditingController();

  static const _allEmojis = [
    '😀','😂','🥰','😎','🤔','😜','🥳','😤',
    '🎉','🔥','❤️','💯','👍','✨','🌟','💥',
    '🎵','🎬','🎮','🏆','🚀','🌈','🦋','🍕',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addSticker(String emoji) {
    ref.read(editorProvider.notifier).addTextOverlay(
          TextOverlay(
            id: const Uuid().v4(),
            text: emoji,
            fontSize: 64,
            colorHex: '#FFFFFF',
            animationName: null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.isEmpty
        ? _allEmojis
        : _allEmojis
            .where((e) => e.contains(_search))
            .toList();

    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Stickers'),
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search emoji…',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon:
                  const Icon(Icons.search, color: Colors.white38, size: 18),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => _addSticker(filtered[i]),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Center(
                    child: Text(filtered[i],
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
