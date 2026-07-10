import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../app/theme.dart';
import '../../models/clip.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../../providers/editor_provider.dart';
import '../../services/permission_service.dart';
import 'project_card.dart';
import 'new_project_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  String _sortBy = 'updated'; // 'updated' | 'created' | 'name'

  @override
  void initState() {
    super.initState();
    PermissionService.requestAll();
  }

  Future<void> _importAndCreate() async {
    await HapticFeedback.selectionClick();
    final picker = ImagePicker();
    final videos = await picker.pickMultipleMedia();
    if (videos.isEmpty || !mounted) return;

    final name = 'Project ${DateTime.now().day}/${DateTime.now().month}';
    final project = await ref.read(projectsProvider.notifier).createProject(name: name);

    final clips = videos.map((v) {
      return VideoClip(
        id: const Uuid().v4(),
        path: v.path,
        name: v.name,
        startTrimSec: 0,
        endTrimSec: 30, // placeholder until metadata loaded
        durationSec: 30,
        timelineStartSec: 0,
      );
    }).toList();

    // Assign timeline positions
    double position = 0;
    for (final clip in clips) {
      clip.timelineStartSec = position;
      position += clip.trimmedDuration;
    }

    project.clips.addAll(clips);
    await ref.read(projectsProvider.notifier).updateProject(project);

    if (mounted) {
      ref.read(editorProvider.notifier).loadProject(project.id);
      context.push('/editor/${project.id}');
    }
  }

  Future<void> _createBlankProject() async {
    await HapticFeedback.selectionClick();
    if (!mounted) return;
    final result = await showModalBottomSheet<Project>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewProjectSheet(),
    );
    if (result != null && mounted) {
      ref.read(editorProvider.notifier).loadProject(result.id);
      context.push('/editor/${result.id}');
    }
  }

  List<Project> _filtered(List<Project> projects) {
    var list = projects.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    switch (_sortBy) {
      case 'name':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'created':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default:
        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final filtered = _filtered(projects);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildSortRow(),
            const Divider(height: 1),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : _buildGrid(filtered),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FrameCut',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  'Professional Video Editor',
                  style: TextStyle(fontSize: 13, color: AppTheme.muted),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.collections_bookmark_outlined),
            onPressed: () => context.push('/templates'),
            tooltip: 'Templates',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.muted),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildSortRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: const TextStyle(fontSize: 12, color: AppTheme.muted),
          ),
          const SizedBox(width: 8),
          _sortChip('updated', 'Recent'),
          const SizedBox(width: 6),
          _sortChip('created', 'Created'),
          const SizedBox(width: 6),
          _sortChip('name', 'Name'),
          const Spacer(),
          Text(
            '${ref.watch(projectsProvider).length} project${ref.watch(projectsProvider).length == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 12, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _sortChip(String value, String label) {
    final selected = _sortBy == value;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppTheme.muted,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<Project> projects) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: projects.length,
      itemBuilder: (context, i) {
        return ProjectCard(
          project: projects[i],
          onTap: () {
            ref.read(editorProvider.notifier).loadProject(projects[i].id);
            context.push('/editor/${projects[i].id}');
          },
          onDelete: () => ref.read(projectsProvider.notifier).deleteProject(projects[i].id),
          onDuplicate: () => ref.read(projectsProvider.notifier).duplicateProject(projects[i].id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.video_library_outlined, size: 32, color: AppTheme.muted),
          ),
          const SizedBox(height: 16),
          const Text(
            'No projects yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primary),
          ),
          const SizedBox(height: 6),
          const Text(
            'Import a video or start from a template',
            style: TextStyle(fontSize: 13, color: AppTheme.muted),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push('/templates'),
            icon: const Icon(Icons.collections_bookmark_outlined, size: 16),
            label: const Text('Browse Templates'),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: 'import',
          onPressed: _importAndCreate,
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text(
            'Import Video',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'new',
          onPressed: _createBlankProject,
          backgroundColor: AppTheme.surface,
          foregroundColor: AppTheme.primary,
          mini: true,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: AppTheme.border),
          ),
          tooltip: 'New blank project',
          child: const Icon(Icons.add_box_outlined, size: 18),
        ),
      ],
    );
  }
}
