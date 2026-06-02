import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../models/user_role.dart';
import '../services/api_service.dart';
import '../utils/logout_helper.dart';
import '../utils/work_history_helper.dart';
import 'login_screen.dart';
import 'staff_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _appVersion = '';
  String _selectedLanguage = 'uz'; // uz or ru
  int _completedTasksToday = 0;
  bool _loadingTasks = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _loadCompletedTasks();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0';
      });
    }
  }

  Future<void> _loadCompletedTasks() async {
    final auth = context.read<AuthProvider>();
    
    // Only load for cleaners
    if (auth.role != UserRole.cleaner) return;
    
    setState(() => _loadingTasks = true);
    
    try {
      final api = ApiService();
      final tasks = await api.getMyTasks();
      
      // Count completed tasks today
      final today = DateTime.now();
      final completedToday = tasks.where((task) {
        if (task['status'] != 'COMPLETED') return false;
        
        final completedAt = task['completedAt'];
        if (completedAt == null) return false;
        
        try {
          final date = DateTime.parse(completedAt);
          return date.year == today.year &&
                 date.month == today.month &&
                 date.day == today.day;
        } catch (e) {
          return false;
        }
      }).length;
      
      setState(() {
        _completedTasksToday = completedToday;
        _loadingTasks = false;
      });
    } catch (e) {
      setState(() => _loadingTasks = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Background with role-based gradient
          Container(
            decoration: BoxDecoration(
              gradient: _getRoleGradient(auth.role),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, auth),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _buildProfileCard(auth),
                          const SizedBox(height: 16),
                          // Work History Card (only for cleaners)
                          if (auth.role == UserRole.cleaner) ...[
                            _buildWorkHistoryCard(),
                            const SizedBox(height: 16),
                          ],
                          _buildSettingsCard(),
                          const SizedBox(height: 16),
                          _buildAppInfoCard(),
                          const SizedBox(height: 24),
                          _buildLogoutButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getRoleGradient(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5E35B1).withOpacity(0.9),
            const Color(0xFF9C27B0).withOpacity(0.8),
          ],
        );
      case UserRole.manager:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1565C0).withOpacity(0.9),
            const Color(0xFF1976D2).withOpacity(0.8),
          ],
        );
      case UserRole.cleaner:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF388E3C).withOpacity(0.9),
            const Color(0xFF43A047).withOpacity(0.8),
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade700.withOpacity(0.9),
            Colors.grey.shade600.withOpacity(0.8),
          ],
        );
    }
  }

  Widget _buildHeader(BuildContext context, AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Shaxsiy ma\'lumotlar',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
              // Settings Icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded, color: Colors.white, size: 22),
                  onPressed: () {},
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          
          // Avatar with role-based gradient
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: _getAvatarGradient(auth.role),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getAvatarColor(auth.role).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                auth.username?.substring(0, 1).toUpperCase() ?? 'A',
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Username
          Text(
            auth.username ?? 'Foydalanuvchi',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getRoleBadgeColor(auth.role),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getRoleEmoji(auth.role),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  _getRoleLabel(auth.role),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getAvatarGradient(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return const LinearGradient(
          colors: [Color(0xFF5E35B1), Color(0xFF9C27B0)],
        );
      case UserRole.manager:
        return const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
        );
      case UserRole.cleaner:
        return const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF43A047)],
        );
      default:
        return LinearGradient(
          colors: [Colors.grey.shade700, Colors.grey.shade600],
        );
    }
  }

  Color _getAvatarColor(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFF5E35B1);
      case UserRole.manager:
        return const Color(0xFF1565C0);
      case UserRole.cleaner:
        return const Color(0xFF388E3C);
      default:
        return Colors.grey;
    }
  }

  Color _getRoleBadgeColor(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return const Color.fromRGBO(94, 53, 177, 0.3);
      case UserRole.manager:
        return const Color.fromRGBO(21, 101, 192, 0.3);
      case UserRole.cleaner:
        return const Color.fromRGBO(76, 175, 80, 0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  String _getRoleEmoji(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return '👑';
      case UserRole.manager:
        return '📊';
      case UserRole.cleaner:
        return '🧹';
      default:
        return '👤';
    }
  }

  String _getRoleLabel(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.manager:
        return 'Menejer';
      case UserRole.cleaner:
        return 'Xodim';
      default:
        return 'Foydalanuvchi';
    }
  }

  Widget _buildProfileCard(AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  color: _getAvatarColor(auth.role),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Shaxsiy ma\'lumotlar',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          
          _buildInfoRow(
            icon: Icons.account_circle_outlined,
            label: 'Foydalanuvchi nomi',
            value: auth.username ?? 'N/A',
          ),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            label: 'Rol',
            value: _getRoleLabel(auth.role),
          ),
          _buildInfoRow(
            icon: Icons.verified_user_outlined,
            label: 'Holat',
            value: 'Faol',
            valueColor: const Color(0xFF4CAF50),
          ),
          
          // Completed tasks (only for cleaners)
          if (auth.role == UserRole.cleaner)
            _buildInfoRow(
              icon: Icons.task_alt_rounded,
              label: 'Bugun bajarilgan vazifalar',
              value: _loadingTasks ? '...' : '$_completedTasksToday ta',
              valueColor: const Color(0xFF1565C0),
            ),
          
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Oxirgi kirish',
            value: _formatLastLogin(),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkHistoryCard() {
    return FutureBuilder<int>(
      future: WorkHistoryHelper.getHistoryCount(),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StaffHistoryScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mening ishlarim',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            count > 0 ? '$count ta ish bajarilgan' : 'Hali ishlar yo\'q',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade400,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.settings_rounded,
                  color: Colors.grey.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sozlamalar',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          
          // Theme Setting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return Icon(
                        themeProvider.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: const Color(0xFF1565C0),
                        size: 20,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tungi rejim',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) {
                          return Text(
                            themeProvider.isDark ? 'Qorong\'u interfeys' : 'Yorug\' interfeys',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade900,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Theme Toggle
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return Switch(
                      value: themeProvider.isDark,
                      activeColor: const Color(0xFF1565C0),
                      onChanged: (_) => themeProvider.toggleTheme(),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          
          // Language Setting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Til',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedLanguage == 'uz' ? 'O\'zbek' : 'Русский',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                // Language Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLanguageButton('uz', 'UZ'),
                      _buildLanguageButton('ru', 'RU'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String code, String label) {
    final isSelected = _selectedLanguage == code;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.grey.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ilova haqida',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          
          _buildInfoRow(
            icon: Icons.phone_android_rounded,
            label: 'Ilova nomi',
            value: 'Room Monitoring',
          ),
          _buildInfoRow(
            icon: Icons.code_rounded,
            label: 'Versiya',
            value: _appVersion.isEmpty ? 'Yuklanmoqda...' : _appVersion,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1565C0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: valueColor ?? Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 66),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _confirmLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          'Chiqish',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  String _formatLastLogin() {
    final now = DateTime.now();
    return DateFormat('dd.MM.yyyy HH:mm').format(now);
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 24),
            const SizedBox(width: 12),
            Text(
              'Chiqish',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          'Tizimdan chiqishni xohlaysizmi?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade300,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Yo\'q',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog
              Navigator.pop(context);
              
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
              
              // Logout
              await context.read<AuthProvider>().logout();
              
              // Close loading
              if (context.mounted) {
                Navigator.pop(context);
              }
              
              // Navigate to login screen and remove all previous routes
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Ha, chiqish',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
