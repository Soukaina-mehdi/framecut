import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/export_settings.dart';

class ProjectsNotifier extends StateNotifier<List<Project>> {
  ProjectsNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box<Project>('projects');
    final all = box.values.where((p) => !p.isTemplate).toList();
    all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = all;
  }

  Future<Project> createProject({
    required String name,
    String aspectRatioName = '9:16',
  }) async {
    final project = Project(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      aspectRatioName: aspectRatioName,
      exportSettings: ExportSettings(),
    );
    final box = Hive.box<Project>('projects');
    await box.put(project.id, project);
    _load();
    return project;
  }

  Future<void> updateProject(Project project) async {
    project.updatedAt = DateTime.now();
    final box = Hive.box<Project>('projects');
    await box.put(project.id, project);
    _load();
  }

  Future<void> deleteProject(String id) async {
    final box = Hive.box<Project>('projects');
    await box.delete(id);
    _load();
  }

  Future<void> duplicateProject(String id) async {
    final box = Hive.box<Project>('projects');
    final original = box.get(id);
    if (original == null) return;
    final copy = Project(
      id: const Uuid().v4(),
      name: '${original.name} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      aspectRatioName: original.aspectRatioName,
      exportSettings: ExportSettings(),
    );
    await box.put(copy.id, copy);
    _load();
  }

  Project? getById(String id) {
    final box = Hive.box<Project>('projects');
    return box.get(id);
  }

  List<Project> get templates {
    final box = Hive.box<Project>('projects');
    return box.values.where((p) => p.isTemplate).toList();
  }
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>((ref) {
  return ProjectsNotifier();
});

final projectByIdProvider = Provider.family<Project?, String>((ref, id) {
  final notifier = ref.watch(projectsProvider.notifier);
  return notifier.getById(id);
});
