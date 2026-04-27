import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<dynamic> _rooms = [];
  bool _loading = true;
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rooms = await ApiService.getRooms();
      setState(() => _rooms = rooms);
    } catch (_) {
      _snack('Xonalarni yuklashda xatolik', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  List<dynamic> get _filtered =>
      _filter == 'ALL' ? _rooms : _rooms.where((r) => r['status'] == _filter).toList();

  Color _color(String s) => switch (s) {
        'CLEAN' => Colors.green,
        'DIRTY' => Colors.red,
        'IN_PROGRESS' => Colors.orange,
        _ => Colors.grey,
      };

  IconData _icon(String s) => switch (s) {
        'CLEAN' => Icons.check_circle,
        'DIRTY' => Icons.cancel,
        'IN_PROGRESS' => Icons.autorenew,
        _ => Icons.help,
      };

  String _label(String s) => switch (s) {
        'CLEAN' => 'Toza',
        'DIRTY' => 'Tozalanmagan',
        'IN_PROGRESS' => 'Jarayonda',
        _ => s,
      };

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> _changeStatus(dynamic room) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xona ${room['roomNumber']} — status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['CLEAN', 'DIRTY', 'IN_PROGRESS']
              .map((s) => ListTile(
                    leading: Icon(_icon(s), color: _color(s)),
                    title: Text(_label(s)),
                    onTap: () => Navigator.pop(context, s),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      try {
        await ApiService.updateRoomStatus(room['id'], selected);
        _load();
      } catch (_) {
        _snack('Statusni yangilashda xatolik', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clean = _rooms.where((r) => r['status'] == 'CLEAN').length;
    final dirty = _rooms.where((r) => r['status'] == 'DIRTY').length;
    final inProgress = _rooms.where((r) => r['status'] == 'IN_PROGRESS').length;

    return Column(
      children: [
        // Statistika
        Container(
          color: const Color(0xFF1565C0),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Jami', _rooms.length, Colors.white),
              _stat('Toza', clean, Colors.green.shade200),
              _stat('Iflos', dirty, Colors.red.shade200),
              _stat('Jarayon', inProgress, Colors.orange.shade200),
            ],
          ),
        ),
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: ['ALL', 'CLEAN', 'DIRTY', 'IN_PROGRESS'].map((f) {
              final sel = _filter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(f == 'ALL' ? 'Barchasi' : _label(f)),
                  selected: sel,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: const Color(0xFF1565C0),
                  labelStyle: TextStyle(
                      color: sel ? Colors.white : Colors.black87),
                ),
              );
            }).toList(),
          ),
        ),
        // Ro'yxat
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _filtered.isEmpty
                      ? const Center(child: Text('Xonalar topilmadi'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final room = _filtered[i];
                            final status = room['status'] as String;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _color(status).withValues(alpha: 0.15),
                                  child: Icon(_icon(status),
                                      color: _color(status)),
                                ),
                                title: Text('Xona ${room['roomNumber']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    '${room['floor'] ?? ''} qavat • ${_label(status)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xFF1565C0)),
                                  onPressed: () => _changeStatus(room),
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

  Widget _stat(String label, int count, Color color) => Column(
        children: [
          Text('$count',
              style: TextStyle(
                  color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      );
}
