import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'rooms_screen.dart';
import 'tasks_screen.dart';
import 'inventory_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  final List<Widget> _screens = const [
    RoomsScreen(),
    TasksScreen(),
    InventoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Monitoring'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Text(
                    auth.username?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.hotel), label: 'Xonalar'),
          NavigationDestination(icon: Icon(Icons.task_alt), label: 'Vazifalar'),
          NavigationDestination(
              icon: Icon(Icons.inventory), label: 'Buyumlar'),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chiqish'),
        content: const Text('Tizimdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Chiqish', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
