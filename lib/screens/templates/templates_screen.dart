import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';

class _TemplateItem {
  final String name;
  final String category;
  final int clipCount;
  final String aspectRatio;
  final Color color;
  const _TemplateItem({
    required this.name, required this.category,
    required this.clipCount, required this.aspectRatio, required this.color,
  });
}

const _templates = [
  _TemplateItem(name: 'Travel Montage', category: 'Travel', clipCount: 12, aspectRatio: '16:9', color: Color(0xFF4A90D9)),
  _TemplateItem(name: 'City Vlog', category: 'Vlog', clipCount: 8, aspectRatio: '9:16', color: Color(0xFF7B68EE)),
  _TemplateItem(name: 'Product Promo', category: 'Promo', clipCount: 6, aspectRatio: '1:1', color: Color(0xFFFF6B6B)),
  _TemplateItem(name: 'Instagram Reel', category: 'Social', clipCount: 5, aspectRatio: '9:16', color: Color(0xFFFF9F43)),
  _TemplateItem(name: 'Wedding Highlights', category: 'Wedding', clipCount: 20, aspectRatio: '16:9', color: Color(0xFFEE82B2)),
  _TemplateItem(name: 'Sports Recap', category: 'Sports', clipCount: 15, aspectRatio: '16:9', color: Color(0xFF00B894)),
  _TemplateItem(name: 'Music Video', category: 'Music', clipCount: 18, aspectRatio: '16:9', color: Color(0xFF6C5CE7)),
  _TemplateItem(name: 'Tutorial', category: 'Vlog', clipCount: 10, aspectRatio: '16:9', color: Color(0xFF2D3436)),
  _TemplateItem(name: 'Food Review', category: 'Vlog', clipCount: 7, aspectRatio: '9:16', color: Color(0xFFE17055)),
  _TemplateItem(name: 'Travel Story', category: 'Travel', clipCount: 9, aspectRatio: '9:16', color: Color(0xFF00CEC9)),
];

const _categories = ['All', 'Travel', 'Vlog', 'Promo', 'Social', 'Wedding', 'Sports', 'Music'];

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TemplatesView();
  }
}

class _TemplatesView extends StatefulWidget {
  @override
  State<_TemplatesView> createState() => _TemplatesViewState();
}

class _TemplatesViewState extends State<_TemplatesView> {
  String _selected = 'All';

  List<_TemplateItem> get _filtered => _selected == 'All'
      ? _templates
      : _templates.where((t) => t.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('Templates', style: TextStyle(
          color: Color(0xFF111111), fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'DM Sans',
        )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: Column(children: [
        // Filter chips
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final isSelected = cat == _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF111111) : AppTheme.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? const Color(0xFF111111) : AppTheme.border),
                  ),
                  alignment: Alignment.center,
                  child: Text(cat, style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF111111),
                    fontFamily: 'DM Sans',
                  )),
                ),
              );
            },
          ),
        ),

        // Grid
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: _filtered.length,
          itemBuilder: (context, i) => _TemplateCard(
            item: _filtered[i],
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Template coming soon'), duration: Duration(seconds: 2)),
            ),
          ),
        )),
      ]),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final _TemplateItem item;
  final VoidCallback onTap;
  const _TemplateCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
            child: Container(
              height: 110, width: double.infinity,
              color: item.color,
              child: Center(child: Icon(Icons.play_circle_outline, color: Colors.white.withOpacity(0.8), size: 36)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: Color(0xFF111111), fontFamily: 'DM Sans',
              ), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                Text('${item.clipCount} clips', style: const TextStyle(
                  fontSize: 11, color: Color(0xFF888888), fontFamily: 'DM Sans',
                )),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(item.aspectRatio, style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: Color(0xFF555555), fontFamily: 'DM Sans',
                  )),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
