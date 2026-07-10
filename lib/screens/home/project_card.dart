import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme.dart';
import '../../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(4),
          color: AppTheme.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildMenu(context),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('MMM d').format(project.updatedAt),
                    style: const TextStyle(fontSize: 11, color: AppTheme.muted),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _pill(project.aspectRatioName),
                      const SizedBox(width: 4),
                      _pill('${project.clips.length} clip${project.clips.length == 1 ? '' : 's'}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return AspectRatio(
      aspectRatio: project.aspectRatioName == '9:16' ? 9 / 16 : 16 / 9,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        child: project.thumbnailPath != null && File(project.thumbnailPath!).existsSync()
            ? Image.file(File(project.thumbnailPath!), fit: BoxFit.cover)
            : Container(
                color: AppTheme.surface,
                child: const Center(
                  child: Icon(Icons.movie_outlined, size: 32, color: AppTheme.muted),
                ),
              ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, size: 16, color: AppTheme.muted),
      padding: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: AppTheme.border),
      ),
      onSelected: (v) {
        if (v == 'duplicate') onDuplicate();
        if (v == 'delete') _confirmDelete(context);
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.copy_outlined, size: 15),
              SizedBox(width: 8),
              Text('Duplicate', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 15, color: AppTheme.destructive),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(fontSize: 13, color: AppTheme.destructive)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text('Delete project?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('"${project.name}" will be permanently deleted.', style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.destructive)),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete();
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: AppTheme.muted)),
    );
  }
}
