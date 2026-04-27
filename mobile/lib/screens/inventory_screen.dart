import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<dynamic> _lowStock = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await ApiService.getLowStock();
      setState(() => _lowStock = items);
    } catch (_) {
      _snack('Buyumlarni yuklashda xatolik');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          color: const Color(0xFF1565C0),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.amber, size: 36),
              const SizedBox(height: 4),
              Text('${_lowStock.length} ta buyum kam qolgan',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Text('Zudlik bilan to\'ldirish kerak',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _lowStock.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 64),
                              SizedBox(height: 12),
                              Text('Barcha buyumlar yetarli!',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _lowStock.length,
                          itemBuilder: (_, i) {
                            final item = _lowStock[i];
                            final qty = item['quantity'] as int;
                            final minQty = item['minQuantity'] as int;
                            final percent = qty / minQty;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.inventory_2,
                                            color: Colors.red),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item['item']?['name'] ?? 'Buyum',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text('$qty / $minQty',
                                              style: TextStyle(
                                                  color: Colors.red.shade700,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        'Xona: ${item['room']?['roomNumber'] ?? ''}',
                                        style: const TextStyle(
                                            color: Colors.black54)),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: percent.clamp(0.0, 1.0),
                                      backgroundColor: Colors.red.shade100,
                                      color: Colors.red,
                                      minHeight: 6,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Minimum: $minQty ta, Hozir: $qty ta',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
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
}
