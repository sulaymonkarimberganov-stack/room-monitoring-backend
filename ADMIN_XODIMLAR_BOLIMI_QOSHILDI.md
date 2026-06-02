# Admin Dashboard - Xodimlar Bo'limi Qo'shildi

## O'zgarishlar

### 1. Backend - User Entity Yangilandi

**Yangi maydonlar qo'shildi** (`app/src/main/java/Mobil/app/entity/User.java`):
```java
private String avatar;        // Avatar initials (e.g., "AK")
private String avatarColor;   // Hex color for avatar (e.g., "#1565C0")
```

### 2. Backend - DataInitializer Yangilandi

**4 ta xodim yaratildi** (`app/src/main/java/Mobil/app/DataInitializer.java`):

| # | Username | Password | Ism | Avatar | Rang | Xonalar | Coins | Vazifalar |
|---|----------|----------|-----|--------|------|---------|-------|-----------|
| 1 | aziz_cleaner | aziz123 | Aziz Karimov | AK | #1565C0 (ko'k) | 1-3 | 150 | 12 |
| 2 | malika_cleaner | malika123 | Malika Rahimova | MR | #5E35B1 (binafsha) | 4-6 | 180 | 15 |
| 3 | jasur_cleaner | jasur123 | Jasur Toshmatov | JT | #2E7D32 (yashil) | 7-9 | 120 | 10 |
| 4 | dilnoza_cleaner | dilnoza123 | Dilnoza Yusupova | DY | #C62828 (qizil) | 10-12 | 200 | 18 |

**12 ta xona yaratildi:**
- Xonalar 1-3 → Aziz Karimov
- Xonalar 4-6 → Malika Rahimova
- Xonalar 7-9 → Jasur Toshmatov
- Xonalar 10-12 → Dilnoza Yusupova

### 3. Backend - UserController Yaratildi

**Yangi controller** (`app/src/main/java/Mobil/app/controller/UserController.java`):

**Endpointlar:**
```
GET /api/users?role=STAFF        - Barcha xodimlarni olish
GET /api/users?role=CLEANER      - Barcha xodimlarni olish (STAFF bilan bir xil)
GET /api/users/{id}/rooms        - Xodimning xonalarini olish
```

**Response format:**
```json
[
  {
    "id": 3,
    "username": "aziz_cleaner",
    "fullName": "Aziz Karimov",
    "role": "STAFF",
    "cleaningCoins": 150,
    "tasksCompleted": 12,
    "avatar": "AK",
    "avatarColor": "#1565C0",
    "assignedRooms": ["1", "2", "3"],
    "createdAt": "2026-05-05T10:30:00"
  }
]
```

### 4. Frontend - StaffScreen Yaratildi

**Yangi ekran** (`mobile/lib/screens/staff_screen.dart`):

**Xususiyatlar:**
- ✅ Barcha xodimlarni ko'rsatish
- ✅ Avatar (initials) rangli doira ichida
- ✅ Online/Offline holati
- ✅ Cleaning coins (yulduzlar bilan)
- ✅ Bajarilgan vazifalar soni
- ✅ Biriktirilgan xonalar ro'yxati
- ✅ Pull-to-refresh
- ✅ Gradient background
- ✅ Glassmorphism dizayn

**Dizayn elementlari:**
```dart
// Avatar
Container(
  width: 60,
  height: 60,
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [avatarColor, avatarColor.withOpacity(0.7)]),
    shape: BoxShape.circle,
    boxShadow: [BoxShadow(color: avatarColor.withOpacity(0.4), blurRadius: 12)],
  ),
  child: Text(avatar, style: TextStyle(fontSize: 22, fontWeight: bold)),
)

// Coins Badge
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFB8960C)]),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Row(
    children: [
      Icon(Icons.stars_rounded, color: white),
      Text('$cleaningCoins'),
    ],
  ),
)

// Stats
Row(
  children: [
    _buildStatItem(Icons.task_alt_rounded, 'Bajarilgan', '$tasksCompleted', green),
    _buildStatItem(Icons.meeting_room_rounded, 'Xonalar', '${assignedRooms.length}', blue),
  ],
)

// Assigned Rooms
Wrap(
  children: assignedRooms.map((room) => 
    Container(
      decoration: BoxDecoration(
        color: white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(RoomFormatter.format(room)),
    ),
  ).toList(),
)
```

### 5. Frontend - ApiService Yangilandi

**Yangi metodlar** (`mobile/lib/services/api_service.dart`):
```dart
Future<List<dynamic>> getStaff() async {
  final res = await http.get(
    Uri.parse('$baseUrl/users?role=STAFF'),
    headers: await _headers(),
  );
  return jsonDecode(res.body);
}

Future<List<dynamic>> getUserRooms(int userId) async {
  final res = await http.get(
    Uri.parse('$baseUrl/users/$userId/rooms'),
    headers: await _headers(),
  );
  return jsonDecode(res.body);
}
```

### 6. Frontend - Admin Dashboard Yangilandi

**Import qo'shildi** (`mobile/lib/screens/admin_dashboard_screen.dart`):
```dart
import 'staff_screen.dart';
```

**Bottom navigation yangilandi:**
```dart
_buildOtherScreens() {
  final screens = [
    const SizedBox(),
    const TasksScreen(),
    const InventoryScreen(),
    const StaffScreen(),  // ← Yangi
    const ProfileScreen(),
  ];
}
```

## Foydalanish

### Backend ishga tushirish:
```bash
cd app
./mvnw spring-boot:run
```

Backend ishga tushganda avtomatik:
- 4 ta xodim yaratiladi
- 12 ta xona yaratiladi
- Har xodimga 3 tadan xona biriktiriladi

### Frontend ishga tushirish:
```bash
cd mobile
flutter run
```

### Login:
```
Admin: admin / admin123
Manager: manager / manager123

Xodimlar:
- aziz_cleaner / aziz123
- malika_cleaner / malika123
- jasur_cleaner / jasur123
- dilnoza_cleaner / dilnoza123
```

### Xodimlar bo'limiga kirish:
1. Admin sifatida login qiling
2. Bottom navigation da "Xodimlar" tugmasini bosing
3. 4 ta xodim ko'rinadi

## Xodim Kartasi Tarkibi

```
┌─────────────────────────────────────────┐
│  [AK]  Aziz Karimov          ⭐ 150    │
│        ● Online                         │
├─────────────────────────────────────────┤
│  ✓ Bajarilgan: 12  │  🚪 Xonalar: 3   │
├─────────────────────────────────────────┤
│  Biriktirilgan xonalar:                 │
│  [1-xona] [2-xona] [3-xona]            │
└─────────────────────────────────────────┘
```

## Rang Sxemasi

| Xodim | Avatar | Rang | Hex |
|-------|--------|------|-----|
| Aziz | AK | Ko'k | #1565C0 |
| Malika | MR | Binafsha | #5E35B1 |
| Jasur | JT | Yashil | #2E7D32 |
| Dilnoza | DY | Qizil | #C62828 |

## API Testlash

### Barcha xodimlarni olish:
```bash
curl -X GET "http://localhost:8080/api/users?role=STAFF" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Xodim xonalarini olish:
```bash
curl -X GET "http://localhost:8080/api/users/3/rooms" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## O'zgartirilgan Fayllar

### Backend:
1. `app/src/main/java/Mobil/app/entity/User.java` - avatar va avatarColor qo'shildi
2. `app/src/main/java/Mobil/app/DataInitializer.java` - 4 xodim va 12 xona
3. `app/src/main/java/Mobil/app/controller/UserController.java` - yangi controller

### Frontend:
1. `mobile/lib/screens/staff_screen.dart` - yangi ekran
2. `mobile/lib/services/api_service.dart` - getStaff() va getUserRooms()
3. `mobile/lib/screens/admin_dashboard_screen.dart` - StaffScreen import

## Xususiyatlar

- ✅ 4 ta xodim
- ✅ 12 ta xona
- ✅ Har xodimga 3 tadan xona
- ✅ Avatar initials
- ✅ Rangli avatarlar
- ✅ Online holati
- ✅ Cleaning coins
- ✅ Bajarilgan vazifalar
- ✅ Biriktirilgan xonalar
- ✅ Pull-to-refresh
- ✅ Glassmorphism dizayn
- ✅ Gradient background
- ✅ Responsive layout

## Kelajakda Qo'shilishi Mumkin

- [ ] Xodim qo'shish/o'chirish
- [ ] Xodimga xona biriktirish/o'chirish
- [ ] Xodim profilini tahrirlash
- [ ] Xodim statistikasi (individual)
- [ ] Xodim holati (online/offline) real-time
- [ ] Xodim reyting tizimi
- [ ] Xodim xabarlar (push notifications)

---

**Sana:** 2026-05-05  
**Status:** ✅ Tayyor  
**Versiya:** 1.0
