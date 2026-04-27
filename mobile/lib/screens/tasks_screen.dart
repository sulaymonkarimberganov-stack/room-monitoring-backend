import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<dynamic> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final auth = context.read<AuthProvider>();
      final tasks = auth.isManager
          ? await ApiService.getAllTasks()
          : await ApiService.getMyTasks();
      setState(() => _tasks = tasks);
    } catch (_) {
      _snack('Vazifalarni yuklashda xatolik', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  Color _color(String s) => switch (s) {
        'PENDING' => Colors.orange,
        'IN_PROGRESS' => Colors.blue,
        'DONE' => Colors.green,
        _ => Colors.grey,
      };

  String _label(String s) => switch (s) {
        'PENDING' => 'Kutilmoqda',
        'IN_PROGRESS' => 'Bajarilmoqda',
        'DONE' => 'Bajarildi',
        _ => s,
      };

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> _changeStatus(dynamic task) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vazifa statusini yangilash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['PENDING', 'IN_PROGRESS', 'DONE']
              .map((s) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _color(s).withValues(alpha: 0.2),
                      radius: 12,
                      child: Icon(Icons.circle, color: _color(s), size: 14),
                    ),
                    title: Text(_label(s)),
                    onTap: () => Navigator.pop(context, s),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      try {
        await ApiService.updateTaskStatus(task['id'], selected);
        _load();
      } catch (_) {
        _snack('Statusni yangilashda xatolik', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Statistika
        Container(
          color: const Color(0xFF1565C0),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Jami', _tasks.length),
              _stat('Kutilmoqda',
                  _tasks.where((t) => t['status'] == 'PENDING').length),
              _stat('Jarayon',
                  _tasks.where((t) => t['status'] == 'IN_PROGRESS').length),
              _stat('Bajarildi',
                  _tasks.where((t) => t['status'] == 'DONE').length),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _tasks.isEmpty
                      ? const Center(child: Text('Vazifalar topilmadi'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _tasks.length,
                          itemBuilder: (_, i) {
                            final task = _tasks[i];
                            final status = task['status'] as String;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Xona ${task['roomNumber']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                _color(status).withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(_label(status),
                                              style: TextStyle(
                                                  color: _color(status),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    if (task['description'] != null) ...[
                                      const SizedBox(height: 4),
                                      Text(task['description'],
                                          style: const TextStyle(
                                              color: Colors.black54)),
                                    ],
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.person,
                                            size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(task['assignedToName'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13)),
                                        const Spacer(),
                                        if (status != 'DONE')
                                          TextButton.icon(
                                            onPressed: () =>
                                                _changeStatus(task),
                                            icon: const Icon(Icons.update,
                                                size: 16),
                                            label: const Text('Yangilash'),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ),
      ],
    );
  }

  Widget _stat(String label, int count) => Column(
        children: [
          Text('$count',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      );
}
