import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../../app/theme.dart';
import '../../providers/editor_provider.dart';

class EditorToolbar extends ConsumerWidget {
  final String projectId;
  const EditorToolbar({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editorProvider);
    final notifier = ref.read(editorProvider.notifier);

    return Container(
      height: 48,
      color: AppTheme.timelineBackground,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Back
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            onPressed: () {
              notifier.saveNow();
              context.pop();
            },
            tooltip: 'Back',
          ),
          // Project name
          Expanded(
            child: Text(
              state.project?.name ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Undo
          IconButton(
            icon: const Icon(Icons.undo_rounded, size: 20),
            color: notifier.canUndo ? Colors.white : Colors.white30,
            padding: const EdgeInsets.all(8),
            onPressed: notifier.canUndo
                ? () async {
                    await HapticFeedback.selectionClick();
                    notifier.undo();
                  }
                : null,
            tooltip: 'Undo',
          ),
          // Redo
          IconButton(
            icon: const Icon(Icons.redo_rounded, size: 20),
            color: notifier.canRedo ? Colors.white : Colors.white30,
            padding: const EdgeInsets.all(8),
            onPressed: notifier.canRedo
                ? () async {
                    await HapticFeedback.selectionClick();
                    notifier.redo();
                  }
                : null,
            tooltip: 'Redo',
          ),
          // Save indicator
          if (state.isDirty)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
            ),
          // Save
          IconButton(
            icon: const Icon(Icons.save_outlined, size: 20),
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            onPressed: () async {
              await HapticFeedback.selectionClick();
              notifier.saveNow();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Project saved'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            tooltip: 'Save',
          ),
          // Export
          GestureDetector(
            onTap: () async {
              await HapticFeedback.selectionClick();
              notifier.saveNow();
              if (context.mounted) context.push('/export/$projectId');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Export',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
