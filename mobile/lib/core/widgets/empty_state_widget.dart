import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1565C0).withOpacity(0.15),
                          const Color(0xFF5E35B1).withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: const Color(0xFF1565C0).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 60,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            if (actionText != null && onAction != null)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Empty rooms widget
class EmptyRoomsWidget extends StatelessWidget {
  final VoidCallback? onAddRoom;

  const EmptyRoomsWidget({
    super.key,
    this.onAddRoom,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.meeting_room_outlined,
      title: 'Xonalar topilmadi',
      description: 'Hozircha birorta xona qo\'shilmagan. Yangi xona qo\'shish uchun pastdagi tugmani bosing.',
      actionText: onAddRoom != null ? 'Xona qo\'shish' : null,
      onAction: onAddRoom,
    );
  }
}

/// Empty tasks widget
class EmptyTasksWidget extends StatelessWidget {
  final VoidCallback? onAddTask;

  const EmptyTasksWidget({
    super.key,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.task_alt_outlined,
      title: 'Vazifalar topilmadi',
      description: 'Sizga hozircha birorta vazifa biriktirilmagan. Yangi vazifalar tez orada paydo bo\'ladi.',
      actionText: onAddTask != null ? 'Vazifa qo\'shish' : null,
      onAction: onAddTask,
    );
  }
}

/// Empty inventory widget
class EmptyInventoryWidget extends StatelessWidget {
  final VoidCallback? onAddItem;

  const EmptyInventoryWidget({
    super.key,
    this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inventory_2_outlined,
      title: 'Buyumlar topilmadi',
      description: 'Omborda hozircha birorta buyum yo\'q. Yangi buyum qo\'shish uchun pastdagi tugmani bosing.',
      actionText: onAddItem != null ? 'Buyum qo\'shish' : null,
      onAction: onAddItem,
    );
  }
}

/// Empty search results widget
class EmptySearchWidget extends StatelessWidget {
  final String? searchQuery;

  const EmptySearchWidget({
    super.key,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Natija topilmadi',
      description: searchQuery != null
          ? '"$searchQuery" bo\'yicha hech narsa topilmadi. Boshqa so\'z bilan qidirib ko\'ring.'
          : 'Qidiruv natijalari topilmadi.',
    );
  }
}

/// Empty notifications widget
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.notifications_none,
      title: 'Bildirishnomalar yo\'q',
      description: 'Sizda hozircha yangi bildirishnomalar yo\'q.',
    );
  }
}
