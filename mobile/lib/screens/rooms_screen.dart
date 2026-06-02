import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../utils/room_formatter.dart';

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
      final api = ApiService();
      final rooms = await api.getRooms();
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
        'CLEAN' => const Color(0xFF2E7D32),        // To'q yashil
        'DIRTY' => const Color(0xFFC62828),        // To'q qizil
        'OCCUPIED' => const Color(0xFFE65100),     // To'q to'q sariq
        'CLEANING' => const Color(0xFFE65100),     // To'q to'q sariq
        'MAINTENANCE' => const Color(0xFF9E9E9E),
        _ => Colors.grey,
      };

  IconData _icon(String s) => switch (s) {
        'CLEAN' => Icons.check_circle_rounded,
        'DIRTY' => Icons.warning_rounded,
        'OCCUPIED' => Icons.cleaning_services_rounded,
        'MAINTENANCE' => Icons.build_rounded,
        _ => Icons.help,
      };

  String _label(String s) => switch (s) {
        'CLEAN' => 'Toza',
        'DIRTY' => 'Tozalanmagan',
        'OCCUPIED' => 'Tozalanmoqda',
        'MAINTENANCE' => 'Ta\'mirlash',
        _ => s,
      };

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _changeStatus(dynamic room) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          RoomFormatter.format(room['roomNumber']),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['CLEAN', 'DIRTY', 'OCCUPIED', 'MAINTENANCE']
              .map((s) => InkWell(
                    onTap: () => Navigator.pop(context, s),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _color(s).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _color(s).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(_icon(s), color: _color(s), size: 24),
                          const SizedBox(width: 12),
                          Text(
                            _label(s),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      try {
        final api = ApiService();
        await api.updateRoomStatus(room['id'], selected);
        _load();
        _snack('Status yangilandi', Colors.green);
      } catch (_) {
        _snack('Statusni yangilashda xatolik', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // Header with title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xona holati',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                // Filter tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterTab('ALL', 'Barchasi', Icons.grid_view_rounded),
                      _buildFilterTab('CLEAN', 'Toza', Icons.check_circle_rounded),
                      _buildFilterTab('OCCUPIED', 'Tozalanmoqda', Icons.cleaning_services_rounded),
                      _buildFilterTab('DIRTY', 'Tozalanmagan', Icons.warning_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Rooms List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _load,
                    child: _filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  'Xonalar topilmadi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) {
                              final room = _filtered[i];
                              final status = room['status'] as String;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: _color(status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_icon(status), color: _color(status), size: 26),
                                  ),
                                  title: Text(
                                    RoomFormatter.format(room['roomNumber']),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _color(status).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _label(status),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: _color(status),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${room['type'] ?? 'Standard'}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1565C0).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.edit_rounded,
                                        color: Color(0xFF1565C0),
                                        size: 20,
                                      ),
                                    ),
                                    onPressed: () => _changeStatus(room),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String value, String label, IconData icon) {
    final isSelected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
