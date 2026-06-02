# ✅ Buyumlar (Inventory) O'zbek Tiliga O'zgartirildi

## 📦 O'zgarishlar

### Backend (Java Spring Boot):

**Fayl:** `app/src/main/java/Mobil/app/DataInitializer.java`

**Eski buyumlar (ingliz tilida):**
- Towels
- Bed Sheets
- Soap
- Shampoo
- Toilet Paper

**Yangi buyumlar (o'zbek tilida):**
- Sochiq
- Choyshab
- Sovun
- Shampun
- Tualet qog'ozi
- Yostiq
- Ko'rpa
- Tozalash spreyi
- Axlat qoplari
- Shippak

---

### Frontend (Flutter):

**Yangi utility fayl:** `mobile/lib/utils/item_translator.dart`

Bu fayl ingliz tilidan o'zbek tiliga tarjima qiladi (legacy support uchun).

```dart
class ItemTranslator {
  static String translate(String? itemName) {
    // 'Towel' → 'Sochiq'
    // 'Soap' → 'Sovun'
    // ...
  }
  
  static String translateCategory(String? category) {
    // 'BATHROOM' → 'Hammom buyumlari'
    // 'BEDROOM' → 'Yotoq buyumlari'
    // ...
  }
}
```

**Yangilangan ekran:** `mobile/lib/screens/inventory_screen.dart`

---

## 📋 To'liq Tarjimalar Ro'yxati

### Hammom Buyumlari (Bathroom):
| Inglizcha | O'zbekcha |
|-----------|-----------|
| Towel | Sochiq |
| Soap | Sovun |
| Shampoo | Shampun |
| Toilet paper | Tualet qog'ozi |
| Toothbrush | Tish cho'tkasi |
| Toothpaste | Tish pastasi |
| Conditioner | Soch kondisioneri |
| Body lotion | Tana losyoni |
| Shower cap | Dush qalpoq |

### Yotoq Buyumlari (Bedroom/Bedding):
| Inglizcha | O'zbekcha |
|-----------|-----------|
| Slippers | Shippak |
| Pillow | Yostiq |
| Blanket | Ko'rpa |
| Bed sheet | Choyshab |
| Pillowcase | Yostiq qopi |

### Tozalash Vositalari (Cleaning):
| Inglizcha | O'zbekcha |
|-----------|-----------|
| Cleaning spray | Tozalash spreyi |
| Mop | Mop (latta) |
| Vacuum bags | Changyutgich qoplari |
| Trash bags | Axlat qoplari |

### Minibar:
| Inglizcha | O'zbekcha |
|-----------|-----------|
| Coffee | Qahva |
| Tea | Choy |
| Sugar | Shakar |
| Water bottle | Suv shishasi |
| Glass | Stakan |

---

## 🏷️ Kategoriyalar

| Inglizcha | O'zbekcha |
|-----------|-----------|
| BATHROOM | Hammom buyumlari |
| BEDROOM / BEDDING | Yotoq buyumlari |
| CLEANING | Tozalash vositalari |
| MINIBAR | Minibar |
| OTHER | Boshqalar |

---

## 📱 Qayerda Ko'rinadi?

### 1. Inventory Screen (Buyumlar Ekrani)
- ✅ Buyum nomlari o'zbekcha
- ✅ Kategoriya nomlari o'zbekcha
- ✅ Filter tugmalar o'zbekcha

### 2. Refill Dialog (To'ldirish So'rovi)
- ✅ Buyum nomi o'zbekcha
- ✅ Dialog sarlavhasi o'zbekcha

### 3. Low Stock Warning (Kam Qoldi Ogohlantirish)
- ✅ Xabar o'zbekcha

### 4. Bildirishnomalar (Notifications)
- ✅ Push notification larda buyum nomlari o'zbekcha

---

## 🔧 Kod Misollari

### Backend (DataInitializer.java):

```java
// Yangi kod (O'zbek tilida):
inventoryRepository.save(new InventoryItem(null, "Sochiq", 50, 20, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Choyshab", 30, 15, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Sovun", 100, 30, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Shampun", 80, 25, "shisha", null));
inventoryRepository.save(new InventoryItem(null, "Tualet qog'ozi", 150, 50, "rulon", null));
inventoryRepository.save(new InventoryItem(null, "Yostiq", 40, 15, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Ko'rpa", 35, 12, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Tozalash spreyi", 25, 10, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Axlat qoplari", 200, 50, "dona", null));
inventoryRepository.save(new InventoryItem(null, "Shippak", 60, 20, "juft", null));
```

### Frontend (inventory_screen.dart):

```dart
// Import qo'shing:
import '../utils/item_translator.dart';

// Buyum nomini ko'rsatish:
Text(
  ItemTranslator.translate(item['name']),  // 'Towel' → 'Sochiq'
  style: GoogleFonts.poppins(...),
),

// Kategoriya nomini ko'rsatish:
Text(
  ItemTranslator.translateCategory(item['category']),  // 'BATHROOM' → 'Hammom buyumlari'
  style: GoogleFonts.poppins(...),
),
```

---

## 📐 O'lchov Birliklari

| Inglizcha | O'zbekcha |
|-----------|-----------|
| pcs | dona |
| bottles | shisha |
| rolls | rulon |
| pairs | juft |

---

## 🔄 Legacy Support

`ItemTranslator` utility ingliz tilidan o'zbek tiliga avtomatik tarjima qiladi. Agar database da eski ingliz nomlar bo'lsa, ular avtomatik o'zbekchaga o'giriladi.

**Misol:**
```dart
ItemTranslator.translate('Towel')      // → 'Sochiq'
ItemTranslator.translate('Sochiq')     // → 'Sochiq' (o'zgarmaydi)
ItemTranslator.translate('Unknown')    // → 'Unknown' (tarjima topilmasa)
```

---

## 📋 Keyingi Qadamlar

### 1. Backend ni Qayta Ishga Tushirish

```bash
cd app
./mvnw spring-boot:run
```

Backend ishga tushganda yangi o'zbek tilida buyumlar yaratiladi.

### 2. Database ni Yangilash (Agar Kerak Bo'lsa)

Agar database da eski ingliz nomlar bo'lsa:

```sql
-- Buyum nomlarini yangilash
UPDATE inventory_items SET name = 'Sochiq' WHERE name = 'Towels';
UPDATE inventory_items SET name = 'Choyshab' WHERE name = 'Bed Sheets';
UPDATE inventory_items SET name = 'Sovun' WHERE name = 'Soap';
UPDATE inventory_items SET name = 'Shampun' WHERE name = 'Shampoo';
UPDATE inventory_items SET name = 'Tualet qog''ozi' WHERE name = 'Toilet Paper';

-- O'lchov birliklarini yangilash
UPDATE inventory_items SET unit = 'dona' WHERE unit = 'pcs';
UPDATE inventory_items SET unit = 'shisha' WHERE unit = 'bottles';
UPDATE inventory_items SET unit = 'rulon' WHERE unit = 'rolls';
```

### 3. Yoki Database ni Tozalash

```sql
-- Barcha buyumlarni o'chirish
DELETE FROM inventory_items;

-- Backend qaytadan ishga tushirilganda yangi formatda yaratiladi
```

---

## 🧪 Test Qilish

1. Backend ni ishga tushiring
2. Database ni tekshiring - buyumlar o'zbek tilida bo'lishi kerak
3. Flutter ilovani oching
4. Inventory ekraniga o'ting
5. Barcha buyumlar o'zbek tilida ko'rinishi kerak:
   - ✅ Sochiq
   - ✅ Sovun
   - ✅ Shampun
   - ✅ Tualet qog'ozi
   - ✅ va boshqalar

---

## ✨ Afzalliklar

1. **Tushunarli** - O'zbek tilida buyum nomlari
2. **Professional** - To'g'ri terminologiya
3. **Legacy Support** - Eski ingliz nomlar ham ishlaydi
4. **Moslashuvchan** - Yangi buyumlar qo'shish oson

---

**Tayyor!** Barcha buyumlar endi o'zbek tilida! 🎉
