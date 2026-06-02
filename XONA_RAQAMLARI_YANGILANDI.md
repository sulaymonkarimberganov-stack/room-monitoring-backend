# ✅ Xona Raqamlari 1-10 Ga O'zgartirildi

## 📱 O'zgarishlar

### Backend (Java Spring Boot):

**Fayl:** `app/src/main/java/Mobil/app/DataInitializer.java`

**Eski format:** 101, 102, 103, ..., 110  
**Yangi format:** 1, 2, 3, ..., 10

```java
// Eski kod:
room.setRoomNumber("10" + i);  // 101, 102, ..., 110

// Yangi kod:
room.setRoomNumber(String.valueOf(i));  // 1, 2, ..., 10
```

### Frontend (Flutter):

**Yangi utility fayl yaratildi:** `mobile/lib/utils/room_formatter.dart`

```dart
class RoomFormatter {
  /// Format room number for display
  /// Examples:
  /// - "1" → "1-xona"
  /// - "101" → "1-xona" (legacy format support)
  /// - "10" → "10-xona"
  static String format(dynamic roomNumber) {
    if (roomNumber == null) return 'N/A';
    
    final String roomStr = roomNumber.toString();
    final int? num = int.tryParse(roomStr);
    
    if (num == null) return '$roomStr-xona';
    
    // Handle legacy format (101-110 → 1-10)
    if (num >= 101 && num <= 110) {
      return '${num - 100}-xona';
    }
    
    // Handle new format (1-10)
    return '$num-xona';
  }
}
```

### Yangilangan Ekranlar:

1. ✅ **rooms_screen.dart** - Xonalar ro'yxati
2. ✅ **cleaner_dashboard_screen.dart** - Xodim dashboard
3. ✅ **qr_scanner_screen.dart** - QR scanner
4. ⏳ **admin_dashboard_screen.dart** - Admin dashboard (qo'lda yangilash kerak)
5. ⏳ **manager_dashboard_screen.dart** - Manager dashboard (qo'lda yangilash kerak)
6. ⏳ **dashboard_screen.dart** - Dashboard (qo'lda yangilash kerak)
7. ⏳ **tasks_screen.dart** - Vazifalar (qo'lda yangilash kerak)

---

## 🔧 Qo'lda Yangilash Kerak Bo'lgan Fayllar

Quyidagi fayllarda `'Xona ${room['roomNumber']}'` ni `RoomFormatter.format(room['roomNumber'])` ga o'zgartiring:

### 1. admin_dashboard_screen.dart

```dart
// Import qo'shing:
import '../utils/room_formatter.dart';

// O'zgartiring (2 joyda):
// Eski:
Text('Xona ${room['roomNumber']}', ...)

// Yangi:
Text(RoomFormatter.format(room['roomNumber']), ...)
```

### 2. manager_dashboard_screen.dart

```dart
// Import qo'shing:
import '../utils/room_formatter.dart';

// O'zgartiring (2 joyda):
Text(RoomFormatter.format(room['roomNumber']), ...)
```

### 3. dashboard_screen.dart

```dart
// Import qo'shing:
import '../utils/room_formatter.dart';

// O'zgartiring (2 joyda):
Text(RoomFormatter.format(room['roomNumber']), ...)
```

### 4. tasks_screen.dart

```dart
// Import qo'shing:
import '../utils/room_formatter.dart';

// O'zgartiring:
Text(RoomFormatter.format(task['roomNumber']), ...)
```

---

## 📋 Backend O'zgarishlarni Qo'llash

### 1. Mavjud Ma'lumotlarni Yangilash

Agar database da allaqachon 101-110 formatida xonalar bo'lsa, ularni yangilash kerak:

**SQL Script:**
```sql
UPDATE rooms SET room_number = '1' WHERE room_number = '101';
UPDATE rooms SET room_number = '2' WHERE room_number = '102';
UPDATE rooms SET room_number = '3' WHERE room_number = '103';
UPDATE rooms SET room_number = '4' WHERE room_number = '104';
UPDATE rooms SET room_number = '5' WHERE room_number = '105';
UPDATE rooms SET room_number = '6' WHERE room_number = '106';
UPDATE rooms SET room_number = '7' WHERE room_number = '107';
UPDATE rooms SET room_number = '8' WHERE room_number = '108';
UPDATE rooms SET room_number = '9' WHERE room_number = '109';
UPDATE rooms SET room_number = '10' WHERE room_number = '110';
```

### 2. Yoki Database ni Tozalash

```sql
-- Barcha ma'lumotlarni o'chirish
DELETE FROM tasks;
DELETE FROM rooms;

-- Backend qaytadan ishga tushirilganda yangi formatda yaratiladi
```

### 3. Backend ni Qayta Ishga Tushirish

```bash
cd app
./mvnw spring-boot:run
```

Backend ishga tushganda `DataInitializer` avtomatik ravishda 1-10 formatida xonalar yaratadi.

---

## 🎯 Ko'rinish

### Eski Format:
- Xona 101
- Xona 102
- ...
- Xona 110

### Yangi Format:
- 1-xona
- 2-xona
- ...
- 10-xona

---

## ✨ Afzalliklar

1. **Oddiyroq** - 1-10 raqamlari tushunarli
2. **Qisqaroq** - "1-xona" vs "Xona 101"
3. **Legacy Support** - Eski 101-110 format ham ishlaydi
4. **Moslashuvchan** - Kelajakda 11, 12, ... qo'shish oson

---

## 🧪 Test Qilish

1. Backend ni ishga tushiring
2. Database ni tekshiring - xonalar 1-10 formatida bo'lishi kerak
3. Flutter ilovani ishga tushiring
4. Barcha ekranlarda xona raqamlari "1-xona", "2-xona" formatida ko'rinishi kerak

---

## 📝 Eslatma

`RoomFormatter.format()` funksiyasi legacy format (101-110) ni ham qo'llab-quvvatlaydi, shuning uchun eski ma'lumotlar bilan ham ishlaydi.

**Tayyor!** 🎉
