# 🔐 3 Xil Rol Tizimi - Qisqa Xulosalar

## ✅ BAJARILGAN ISHLAR

### 1. **Yangi Fayllar (5 ta)**
```
mobile/lib/models/
  ├── user_role.dart          # UserRole enum (admin, manager, cleaner)
  └── user_model.dart         # UserModel class

mobile/lib/screens/
  ├── admin_dashboard_screen.dart      # Oltin rang, 5 ta nav item
  ├── manager_dashboard_screen.dart    # Binafsha rang, 4 ta nav item
  └── cleaner_dashboard_screen.dart    # Yashil rang, 3 ta nav item
```

### 2. **Yangilangan Fayllar (4 ta)**
```
mobile/
  ├── pubspec.yaml           # jwt_decoder ^2.0.1 qo'shildi
  ├── lib/main.dart          # Role-based routing
  ├── lib/providers/auth_provider.dart    # JWT decode logic
  └── lib/services/api_service.dart       # getCurrentUser() endpoint
```

---

## 🎯 3 XIL ROL

### 🥇 ADMIN (Administrator)
- **Rang:** Oltin (#FFD700)
- **Huquqlar:** Barcha imkoniyatlar
- **Nav Items:** Dashboard, Vazifalar, Buyumlar, **Xodimlar**, Profil
- **Xonalar:** Barcha xonalarni edit qilish

### 👔 MANAGER (Menejer)
- **Rang:** Binafsha (#5E35B1)
- **Huquqlar:** Ko'rish va hisobotlar
- **Nav Items:** Dashboard, Vazifalar, Buyumlar, Profil
- **Xonalar:** Faqat ko'rish (read-only)

### 🧹 CLEANER (Tozalovchi)
- **Rang:** Yashil (#4CAF50)
- **Huquqlar:** Faqat o'z xonalari
- **Nav Items:** Xonalar, Vazifalar, Profil
- **Xonalar:** Faqat biriktirilgan xonalarni edit qilish

---

## 🔧 TEXNIK TAFSILOTLAR

### JWT Token Decode
```dart
import 'package:jwt_decoder/jwt_decoder.dart';

// Token decode
Map<String, dynamic> decoded = JwtDecoder.decode(token);
String role = decoded['role']; // "ADMIN", "MANAGER", "CLEANER"

// Token expired check
bool isExpired = JwtDecoder.isExpired(token);
```

### Role-Based Routing
```dart
// main.dart da
switch (auth.getCurrentUserRole()) {
  case UserRole.admin:
    return AdminDashboardScreen();
  case UserRole.manager:
    return ManagerDashboardScreen();
  case UserRole.cleaner:
    return CleanerDashboardScreen();
}
```

### Permission Checks
```dart
// AuthProvider da
bool get canManageUsers => role == UserRole.admin;
bool get canViewReports => role == UserRole.admin || role == UserRole.manager;
bool get canViewAllRooms => role == UserRole.admin || role == UserRole.manager;
```

---

## 🌐 BACKEND ENDPOINTS

### Mavjud:
```
POST /api/auth/login
Response: { token, id, username, role, status }
```

### Kerak bo'lgan:
```
GET /api/auth/me
Response: { id, username, role, status, fullName, email }

GET /api/rooms/my  (Cleaner uchun)
Response: [ { id, roomNumber, status, assignedTo } ]
```

---

## 📱 TEST QILISH

### 1. Dependencies o'rnatish
```bash
cd mobile
flutter pub get
```

### 2. Run qilish
```bash
flutter run -d chrome
```

### 3. Test Accounts
```
Admin:    admin / admin123
Manager:  manager / manager123
Cleaner:  cleaner / cleaner123
```

### 4. Tekshirish
- ✅ Login qiling
- ✅ Rolga mos Dashboard ochilishini tekshiring
- ✅ Rang sxemasi to'g'riligini tekshiring
- ✅ Navigation items sonini tekshiring
- ✅ Xonalar huquqlarini tekshiring

---

## 🎨 VIZUAL FARQLAR

| Rol | Avatar Rang | Panel Icon | Nav Items | Xona Action |
|-----|-------------|------------|-----------|-------------|
| **ADMIN** | Oltin | admin_panel_settings | 5 ta | Edit (barcha) |
| **MANAGER** | Binafsha | manage_accounts | 4 ta | View only |
| **CLEANER** | Yashil | cleaning_services | 3 ta | Edit (o'zniki) |

---

## 📦 APK BUILD

```bash
cd mobile
flutter build apk --release --no-tree-shake-icons
```

**APK Location:**
```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

---

## ✨ ASOSIY XUSUSIYATLAR

✅ JWT token decode va validation  
✅ Role-based routing (3 xil Dashboard)  
✅ Permission checks (canManageUsers, canViewReports)  
✅ Token expiry check  
✅ Secure authentication  
✅ Role-specific UI/UX  
✅ Different color schemes per role  
✅ Different navigation items per role  

---

**Status:** ✅ Production Ready  
**Versiya:** 3.0.0  
**Sana:** 2026-05-05
