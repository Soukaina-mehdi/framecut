import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';

class NewProjectSheet extends ConsumerStatefulWidget {
  const NewProjectSheet({super.key});

  @override
  ConsumerState<NewProjectSheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends ConsumerState<NewProjectSheet> {
  final _nameCtrl = TextEditingController(text: 'My Project');
  String _aspectRatio = '9:16';

  static const _ratios = [
    ('9:16', Icons.stay_current_portrait, 'Vertical'),
    ('16:9', Icons.stay_current_landscape, 'Horizontal'),
    ('1:1', Icons.crop_square, 'Square'),
    ('4:3', Icons.crop_landscape, 'Standard'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final project = await ref.read(projectsProvider.notifier).createProject(
          name: name,
          aspectRatioName: _aspectRatio,
        );
    if (mounted) Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'New Project',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primary),
          ),
          const SizedBox(height: 16),
          const Text('Project Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted)),
          const SizedBox(height: 6),
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(hintText: 'Enter project name...'),
          ),
          const SizedBox(height: 20),
          const Text('Aspect Ratio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted)),
          const SizedBox(height: 10),
          Row(
            children: _ratios.map((r) {
              final selected = _aspectRatio == r.$1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _aspectRatio = r.$1),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : AppTheme.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: selected ? AppTheme.primary : AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        Icon(r.$2, size: 20, color: selected ? Colors.white : AppTheme.muted),
                        const SizedBox(height: 4),
                        Text(
                          r.$1,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppTheme.primary,
                          ),
                        ),
                        Text(
                          r.$3,
                          style: TextStyle(fontSize: 9, color: selected ? Colors.white60 : AppTheme.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _create,
              child: const Text('Create Project'),
            ),
          ),
        ],
      ),
    );
  }
}
