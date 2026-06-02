import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../utils/room_formatter.dart';

class ManagerRoomsScreen extends StatefulWidget {
  const ManagerRoomsScreen({super.key});

  @override
  State<ManagerRoomsScreen> createState() => _ManagerRoomsScreenState();
}

class _ManagerRoomsScreenState extends State<ManagerRoomsScreen> {
  List<dynamic> _rooms = [];
  bool _loading = true;
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() => _loading = true);
    try {
      final api = ApiService();
      final rooms = await api.getRooms();
      setState(() {
        _rooms = rooms;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Xonalarni yuklashda xatolik: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  List<dynamic> get _filteredRooms {
    if (_filter == 'ALL') return _rooms;
    if (_filter == 'CLEAN') return _rooms.where((r) => r['status'] == 'CLEAN').toList();
    if (_filter == 'DIRTY') return _rooms.where((r) => r['status'] == 'DIRTY').toList();
    if (_filter == 'OCCUPIED') return _rooms.where((r) => r['status'] == 'OCCUPIED').toList();
    return _rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628), // TO'Q KO'K-QORA
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F3C), // TO'Q KO'K
        elevation: 0,
        title: Text(
          'Xonalar',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Stats Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF0D1F3C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Jami',
                  '${_rooms.length}',
                  Icons.bed_rounded,
                  const Color(0xFF1565C0),
                ),
                _buildStatItem(
                  'Toza',
                  '${_rooms.where((r) => r['status'] == 'CLEAN').length}',
                  Icons.check_circle_rounded,
                  const Color(0xFF2E7D32),
                ),
                _buildStatItem(
                  'Iflos',
                  '${_rooms.where((r) => r['status'] == 'DIRTY').length}',
                  Icons.cancel_rounded,
                  const Color(0xFFC62828),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton('ALL', 'Barchasi'),
                  const SizedBox(width: 8),
                  _buildFilterButton('CLEAN', 'Toza'),
                  const SizedBox(width: 8),
                  _buildFilterButton('DIRTY', 'Iflos'),
                  const SizedBox(width: 8),
                  _buildFilterButton('OCCUPIED', 'Jarayonda'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Rooms List
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1565C0),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadRooms,
                    color: const Color(0xFF1565C0),
                    child: _filteredRooms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bed_outlined,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Xonalar topilmadi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _filteredRooms.length,
                            itemBuilder: (context, index) {
                              final room = _filteredRooms[index];
                              return _buildRoomCard(room);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = _filter == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _filter = value),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF1A2744),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF2A3F6F),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(dynamic room) {
    final roomNumber = room['roomNumber'] ?? '';
    final status = room['status'] ?? 'CLEAN';
    final type = room['type'] ?? 'STANDARD';

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (status) {
      case 'CLEAN':
        statusColor = const Color(0xFF2E7D32);
        statusIcon = Icons.check_circle_rounded;
        statusLabel = 'Toza';
        break;
      case 'DIRTY':
        statusColor = const Color(0xFFC62828);
        statusIcon = Icons.cancel_rounded;
        statusLabel = 'Iflos';
        break;
      case 'OCCUPIED':
        statusColor = const Color(0xFFE65100);
        statusIcon = Icons.access_time_rounded;
        statusLabel = 'Jarayonda';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_rounded;
        statusLabel = status;
    }

    String typeLabel = _getRoomTypeLabel(type);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744), // TO'Q KO'K BACKGROUND
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A3F6F), // KO'RINADIGAN BORDER
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showRoomDetails(room),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Room Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Room Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RoomFormatter.format(roomNumber),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white, // TO'LIQ OQ
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$typeLabel • $statusLabel',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70, // 70% OQ
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRoomTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'STANDARD':
        return 'Standart';
      case 'DOUBLE':
        return 'Ikki kishilik';
      case 'LUXURY':
        return 'Lyuks';
      case 'SUITE':
        return 'Suite';
      case 'MAINTENANCE':
        return 'Ta\'mirlash';
      default:
        return type;
    }
  }

  void _showRoomDetails(dynamic room) {
    final roomNumber = room['roomNumber'] ?? '';
    final status = room['status'] ?? 'CLEAN';
    final type = room['type'] ?? 'STANDARD';
    final roomId = room['id'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A2744),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF2A3F6F),
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        RoomFormatter.format(roomNumber),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Details
                _buildDetailRow('Turi:', _getRoomTypeLabel(type)),
                const SizedBox(height: 8),
                _buildDetailRow('Holati:', _getStatusLabel(status)),
                const SizedBox(height: 16),
                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1F3C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2A3F6F),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF1565C0),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Menejer faqat ko\'rish huquqiga ega',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Photos Section
                _buildPhotosSection(roomId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'CLEAN':
        return 'Toza';
      case 'DIRTY':
        return 'Iflos';
      case 'OCCUPIED':
        return 'Jarayonda';
      default:
        return status;
    }
  }

  Widget _buildPhotosSection(int roomId) {
    return FutureBuilder<List<dynamic>>(
      future: _getRoomPhotos(roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Color(0xFF1565C0),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1F3C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2A3F6F),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white38,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hali surat yuklanmagan',
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        final photos = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tozalik suratlari',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () => _showFullPhoto(context, photo['url']),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF2A3F6F),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                photo['url'],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF0D1F3C),
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white38,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: const Color(0xFF0D1F3C),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF1565C0),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            photo['staffName'] ?? 'Noma\'lum',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            photo['uploadedAt'] ?? '',
                            style: GoogleFonts.poppins(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> _getRoomPhotos(int roomId) async {
    try {
      final api = ApiService();
      final response = await api.getRoomPhotos(roomId);
      return response;
    } catch (e) {
      return [];
    }
  }

  void _showFullPhoto(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image,
                          color: Colors.white38,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Rasmni yuklab bo\'lmadi',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF1565C0),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
