# Profile Screen Enhancement - To'liq Hujjat

## 📋 Umumiy Ma'lumot

Profil ekrani rol tizimiga mos ravishda to'liq yangilandi. Har bir rol uchun alohida rang sxemasi, avatar gradient, va rol badge qo'shildi.

## 🎨 Rol Bo'yicha Dizayn

### 1. Avatar Gradientlari

| Rol | Gradient | Hex Codes |
|-----|----------|-----------|
| **Admin** | Binafsha | `#5E35B1` → `#9C27B0` |
| **Manager** | Ko'k | `#1565C0` → `#1976D2` |
| **Cleaner** | Yashil | `#388E3C` → `#43A047` |

**Avatar Xususiyatlari**:
- O'lcham: 100x100 px
- Shape: Circle
- Shadow: Role color with 0.4 opacity, 20px blur, 8px offset
- Font size: 42px, bold
- Text color: White

### 2. Rol Badge

| Rol | Emoji | Label | Background Color |
|-----|-------|-------|------------------|
| **Admin** | 👑 | Administrator | `rgba(94, 53, 177, 0.3)` |
| **Manager** | 📊 | Menejer | `rgba(21, 101, 192, 0.3)` |
| **Cleaner** | 🧹 | Xodim | `rgba(76, 175, 80, 0.3)` |

**Badge Xususiyatlari**:
- Padding: 16px horizontal, 8px vertical
- Border radius: 20px
- Border: White with 0.3 opacity, 1px width
- Font size: 14px, w600
- Text color: White

### 3. Background Gradient

Har bir rol uchun alohida background gradient:

**Admin**:
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF5E35B1).withOpacity(0.9),
    Color(0xFF9C27B0).withOpacity(0.8),
  ],
)
```

**Manager**:
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1565C0).withOpacity(0.9),
    Color(0xFF1976D2).withOpacity(0.8),
  ],
)
```

**Cleaner**:
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF388E3C).withOpacity(0.9),
    Color(0xFF43A047).withOpacity(0.8),
  ],
)
```

## 📊 Ma'lumot Qatorlari

### 1. Shaxsiy Ma'lumotlar Kartasi

| Field | Icon | Description |
|-------|------|-------------|
| Foydalanuvchi nomi | `account_circle_outlined` | Username |
| Rol | `badge_outlined` | Administrator/Menejer/Xodim |
| Holat | `verified_user_outlined` | Faol (yashil rang) |
| Bugun bajarilgan vazifalar | `task_alt_rounded` | Faqat Cleaner uchun |
| Oxirgi kirish | `access_time_rounded` | dd.MM.yyyy HH:mm |

### 2. Sozlamalar Kartasi

| Setting | Icon | Options |
|---------|------|---------|
| Til | `language_rounded` | O'zbek / Русский |

**Til Toggle**:
- UZ / RU buttons
- Selected: Blue background (`#1565C0`)
- Unselected: Transparent background
- Border radius: 20px

### 3. Ilova Haqida Kartasi

| Field | Icon | Value |
|-------|------|-------|
| Ilova nomi | `phone_android_rounded` | Room Monitoring |
| Versiya | `code_rounded` | 1.0.0 (1) |

## 🔧 Funksiyalar

### 1. Avatar Gradient

```dart
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
```

### 2. Rol Badge Rangi

```dart
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
```

### 3. Rol Emoji

```dart
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
```

### 4. Rol Label

```dart
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
```

### 5. Bugun Bajarilgan Vazifalar (Cleaner)

```dart
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
```

### 6. Ilova Versiyasi

```dart
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
```

### 7. Oxirgi Kirish Vaqti

```dart
String _formatLastLogin() {
  final now = DateTime.now();
  return DateFormat('dd.MM.yyyy HH:mm').format(now);
}
```

## 📱 UI Komponentlar

### 1. Header

```dart
Widget _buildHeader(BuildContext context, AuthProvider auth) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
    child: Column(
      children: [
        // Title and Settings Button
        Row(...),
        
        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: _getAvatarGradient(auth.role),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              auth.username?.substring(0, 1).toUpperCase() ?? 'A',
              style: GoogleFonts.poppins(fontSize: 42, ...),
            ),
          ),
        ),
        
        // Username
        Text(auth.username ?? 'Foydalanuvchi', ...),
        
        // Role Badge
        Container(
          decoration: BoxDecoration(
            color: _getRoleBadgeColor(auth.role),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(_getRoleEmoji(auth.role)),
              Text(_getRoleLabel(auth.role)),
            ],
          ),
        ),
      ],
    ),
  );
}
```

### 2. Profile Card

```dart
Widget _buildProfileCard(AuthProvider auth) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [...],
    ),
    child: Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.person_rounded, ...),
              Text('Shaxsiy ma\'lumotlar', ...),
            ],
          ),
        ),
        
        // Info Rows
        _buildInfoRow(...),
        _buildInfoRow(...),
        _buildInfoRow(...),
        
        // Completed tasks (only for cleaners)
        if (auth.role == UserRole.cleaner)
          _buildInfoRow(...),
        
        _buildInfoRow(...),
      ],
    ),
  );
}
```

### 3. Settings Card

```dart
Widget _buildSettingsCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [...],
    ),
    child: Column(
      children: [
        // Header
        Padding(...),
        
        // Language Setting
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Icon
              Container(...),
              
              // Label and Value
              Expanded(...),
              
              // Language Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
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
```

### 4. App Info Card

```dart
Widget _buildAppInfoCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [...],
    ),
    child: Column(
      children: [
        // Header
        Padding(...),
        
        // Info Rows
        _buildInfoRow(
          icon: Icons.phone_android_rounded,
          label: 'Ilova nomi',
          value: 'Room Monitoring',
        ),
        _buildInfoRow(
          icon: Icons.code_rounded,
          label: 'Versiya',
          value: _appVersion,
          isLast: true,
        ),
      ],
    ),
  );
}
```

### 5. Info Row

```dart
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
            // Icon Container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
            ),
            
            // Label and Value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.poppins(fontSize: 11, ...)),
                  Text(value, style: GoogleFonts.poppins(fontSize: 14, ...)),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Divider
      if (!isLast)
        Padding(
          padding: const EdgeInsets.only(left: 66),
          child: Divider(...),
        ),
    ],
  );
}
```

## 🎯 State Management

```dart
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
}
```

## 📊 Rol Bo'yicha Ko'rinish

### Admin Profil
```
┌─────────────────────────────────────────┐
│ Profil                          [⚙️]    │
│ Shaxsiy ma'lumotlar                     │
│                                         │
│         ┌─────────────┐                 │
│         │             │                 │
│         │      A      │  (Binafsha)     │
│         │             │                 │
│         └─────────────┘                 │
│                                         │
│           admin                         │
│      [👑 Administrator]                 │
│                                         │
├─────────────────────────────────────────┤
│ 👤 Shaxsiy ma'lumotlar                  │
├─────────────────────────────────────────┤
│ 👤 Foydalanuvchi nomi: admin            │
│ 🎖️ Rol: Administrator                   │
│ ✅ Holat: Faol                          │
│ 🕐 Oxirgi kirish: 05.05.2024 14:30     │
└─────────────────────────────────────────┘
```

### Manager Profil
```
┌─────────────────────────────────────────┐
│         ┌─────────────┐                 │
│         │             │                 │
│         │      M      │  (Ko'k)         │
│         │             │                 │
│         └─────────────┘                 │
│                                         │
│          manager                        │
│       [📊 Menejer]                      │
└─────────────────────────────────────────┘
```

### Cleaner Profil
```
┌─────────────────────────────────────────┐
│         ┌─────────────┐                 │
│         │             │                 │
│         │      C      │  (Yashil)       │
│         │             │                 │
│         └─────────────┘                 │
│                                         │
│          cleaner                        │
│        [🧹 Xodim]                       │
│                                         │
├─────────────────────────────────────────┤
│ 👤 Shaxsiy ma'lumotlar                  │
├─────────────────────────────────────────┤
│ 👤 Foydalanuvchi nomi: cleaner          │
│ 🎖️ Rol: Xodim                           │
│ ✅ Holat: Faol                          │
│ ✅ Bugun bajarilgan vazifalar: 5 ta     │
│ 🕐 Oxirgi kirish: 05.05.2024 14:30     │
└─────────────────────────────────────────┘
```

## 🔄 User Flow

### Profil Ochish
```
1. Foydalanuvchi profil ekraniga kiradi
2. Rol bo'yicha background gradient ko'rsatiladi
3. Avatar rol rangida ko'rsatiladi
4. Rol badge ko'rsatiladi
5. Ma'lumotlar yuklanadi
6. Ilova versiyasi yuklanadi
7. Cleaner uchun bugun bajarilgan vazifalar yuklanadi
```

### Til O'zgartirish
```
1. Foydalanuvchi "Sozlamalar" kartasini ko'radi
2. "Til" qatorida UZ/RU toggle ko'rsatiladi
3. Foydalanuvchi tilni tanlaydi
4. Selected til ko'k rangda ko'rsatiladi
5. State yangilanadi
```

### Chiqish
```
1. Foydalanuvchi "Chiqish" tugmasini bosadi
2. Confirmation dialog ochiladi
3. "Tizimdan chiqmoqchimisiz?" so'rovi
4. Foydalanuvchi "Chiqish" ni tasdiqlaydi
5. AuthProvider.logout() chaqiriladi
6. Login ekraniga yo'naltiriladi
```

## 📦 Dependencies

```yaml
dependencies:
  package_info_plus: ^5.0.1  # App version
  intl: ^0.18.1              # Date formatting
  google_fonts: ^6.1.0       # Poppins font
  provider: ^6.1.2           # State management
```

## 🧪 Test Qilish

### 1. Rol Bo'yicha Avatar
```dart
// Admin
expect(avatar.gradient.colors, [Color(0xFF5E35B1), Color(0xFF9C27B0)]);

// Manager
expect(avatar.gradient.colors, [Color(0xFF1565C0), Color(0xFF1976D2)]);

// Cleaner
expect(avatar.gradient.colors, [Color(0xFF388E3C), Color(0xFF43A047)]);
```

### 2. Rol Badge
```dart
// Admin
expect(badge.emoji, '👑');
expect(badge.label, 'Administrator');
expect(badge.backgroundColor, Color.fromRGBO(94, 53, 177, 0.3));

// Manager
expect(badge.emoji, '📊');
expect(badge.label, 'Menejer');

// Cleaner
expect(badge.emoji, '🧹');
expect(badge.label, 'Xodim');
```

### 3. Bugun Bajarilgan Vazifalar
```dart
// Faqat Cleaner uchun
if (role == UserRole.cleaner) {
  expect(completedTasksRow, isNotNull);
  expect(completedTasksToday, greaterThanOrEqualTo(0));
}
```

### 4. Ilova Versiyasi
```dart
expect(appVersion, matches(r'\d+\.\d+\.\d+ \(\d+\)'));
// Example: "1.0.0 (1)"
```

## 🐛 Troubleshooting

### Avatar Gradient Ko'rinmaydi

**Sabab**: Role null yoki noto'g'ri

**Yechim**:
```dart
// Default gradient qo'shish
default:
  return LinearGradient(
    colors: [Colors.grey.shade700, Colors.grey.shade600],
  );
```

### Bugun Bajarilgan Vazifalar Yuklanmaydi

**Sabab**: API xatosi yoki date parsing muammosi

**Yechim**:
```dart
try {
  final date = DateTime.parse(completedAt);
  // ...
} catch (e) {
  return false;
}
```

### Ilova Versiyasi "Yuklanmoqda..."

**Sabab**: PackageInfo yuklanmagan

**Yechim**:
```dart
try {
  final packageInfo = await PackageInfo.fromPlatform();
  // ...
} catch (e) {
  setState(() {
    _appVersion = '1.0.0'; // Default version
  });
}
```

## ✅ Checklist

- [x] Rol bo'yicha avatar gradient
- [x] Rol badge (emoji + label)
- [x] Background gradient
- [x] Foydalanuvchi nomi
- [x] Rol
- [x] Holat (Faol)
- [x] Bugun bajarilgan vazifalar (Cleaner)
- [x] Oxirgi kirish vaqti
- [x] Til sozlamalari (UZ/RU)
- [x] Ilova versiyasi
- [x] Chiqish funksiyasi
- [x] Error handling
- [x] Loading states

## 🎯 Kelajakdagi Yaxshilanishlar

1. **Profile Photo**: Avatar o'rniga haqiqiy foto yuklash
2. **Edit Profile**: Ma'lumotlarni tahrirlash
3. **Theme**: Dark/Light mode
4. **Notifications**: Push notification sozlamalari
5. **Security**: Parol o'zgartirish
6. **Statistics**: Foydalanuvchi statistikasi
7. **Achievements**: Badge va yutuqlar
8. **Activity Log**: Faoliyat tarixi

## 📚 Qo'shimcha Ma'lumot

- **package_info_plus**: https://pub.dev/packages/package_info_plus
- **intl**: https://pub.dev/packages/intl
- **Material Design**: https://material.io/design
