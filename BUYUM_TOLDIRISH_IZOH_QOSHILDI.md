# Buyum To'ldirish So'roviga Izoh Maydoni Qo'shildi

## O'zgarishlar

### 1. Dialog Yangilandi (`mobile/lib/screens/inventory_screen.dart`)

**Yangi funksiyalar:**
- ✅ Miqdorni +/- tugmalar bilan o'zgartirish
- ✅ Izoh maydoni (3 qator, maksimal 200 belgi)
- ✅ StatefulBuilder ishlatildi (dialog ichida state boshqarish uchun)
- ✅ SingleChildScrollView qo'shildi (kichik ekranlar uchun)
- ✅ Yangilangan dizayn va layout

**Dialog tarkibi:**
```dart
Future<void> _showRefillDialog(dynamic item) async {
  int quantity = 1;
  String comment = '';
  
  // StatefulBuilder - dialog ichida quantity o'zgartirish uchun
  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => Dialog(
        // ... dialog content
      ),
    ),
  );
}
```

**Miqdor tanlash:**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      icon: Icon(Icons.remove_circle, color: Color(0xFF1565C0), size: 36),
      onPressed: () {
        if (quantity > 1) {
          setDialogState(() => quantity--);
        }
      },
    ),
    Text('$quantity', style: TextStyle(fontSize: 28, fontWeight: bold)),
    IconButton(
      icon: Icon(Icons.add_circle, color: Color(0xFF1565C0), size: 36),
      onPressed: () {
        setDialogState(() => quantity++);
      },
    ),
  ],
)
```

**Izoh maydoni:**
```dart
TextField(
  maxLines: 3,
  maxLength: 200,
  decoration: InputDecoration(
    hintText: 'Izoh qoldiring (ixtiyoriy)...',
    filled: true,
    fillColor: Colors.white.withOpacity(0.08),
    // ... styling
  ),
  onChanged: (val) => comment = val,
)
```

### 2. Submit Metodi Yangilandi

**Eski:**
```dart
Future<void> _submitRefillRequest(int itemId, int quantity) async {
  await api.requestInventoryRefill(itemId, quantity);
}
```

**Yangi:**
```dart
Future<void> _submitRefillRequest(int itemId, int quantity, String comment) async {
  await api.requestInventoryRefill(itemId, quantity, comment);
}
```

### 3. API Service Yangilandi (`mobile/lib/services/api_service.dart`)

**Eski:**
```dart
Future<Map<String, dynamic>> requestInventoryRefill(int itemId, int quantity) async {
  final res = await http.post(
    Uri.parse('$baseUrl/inventory/$itemId/request'),
    headers: await _headers(),
    body: jsonEncode({'quantity': quantity}),
  );
  // ...
}
```

**Yangi:**
```dart
Future<Map<String, dynamic>> requestInventoryRefill(int itemId, int quantity, String comment) async {
  final res = await http.post(
    Uri.parse('$baseUrl/inventory/$itemId/request'),
    headers: await _headers(),
    body: jsonEncode({
      'quantity': quantity,
      'comment': comment.isNotEmpty ? comment : null,
    }),
  );
  // ...
}
```

## Foydalanish

1. **Buyumlar ekranida** "To'ldirish so'rovi" tugmasini bosing
2. **Miqdorni tanlang:** +/- tugmalar bilan
3. **Izoh qoldiring:** (ixtiyoriy) - maksimal 200 belgi
4. **"Yuborish"** tugmasini bosing

## Xususiyatlar

- ✅ Miqdor minimal 1 dan boshlanadi
- ✅ Izoh ixtiyoriy (bo'sh bo'lsa null yuboriladi)
- ✅ Belgilar soni ko'rsatiladi (200 maksimal)
- ✅ Responsive dizayn (kichik ekranlar uchun scroll)
- ✅ Yaxshilangan UI/UX
- ✅ Bekor qilish va yuborish tugmalari

## Backend Integratsiya

API endpoint:
```
POST /api/inventory/{itemId}/request
```

Request body:
```json
{
  "quantity": 5,
  "comment": "Xonalar uchun shoshilinch kerak"
}
```

Agar izoh bo'sh bo'lsa:
```json
{
  "quantity": 5,
  "comment": null
}
```

## O'zgartirilgan Fayllar

1. `mobile/lib/screens/inventory_screen.dart`
   - `_showRefillDialog()` metodi to'liq qayta yozildi
   - `_submitRefillRequest()` metodiga `comment` parametri qo'shildi

2. `mobile/lib/services/api_service.dart`
   - `requestInventoryRefill()` metodiga `comment` parametri qo'shildi
   - API request body yangilandi

## Test Qilish

1. Ilovani ishga tushiring
2. Manager yoki Admin sifatida kiring
3. Buyumlar (Inventory) ekraniga o'ting
4. Biror buyumda "To'ldirish so'rovi" tugmasini bosing
5. Miqdorni +/- bilan o'zgartiring
6. Izoh yozing (yoki bo'sh qoldiring)
7. "Yuborish" tugmasini bosing
8. "So'rov yuborildi!" xabari ko'rinishi kerak

## Dizayn

- **Rang sxemasi:** Ko'k gradient (#1565C0 → #5E35B1)
- **Miqdor tugmalari:** 36px ko'k doira ikonkalar
- **Izoh maydoni:** 3 qator, 200 belgi limit
- **Font:** Google Fonts Poppins
- **Animatsiya:** Backdrop blur effekt
- **Responsive:** SingleChildScrollView bilan

---

**Sana:** 2026-05-05  
**Status:** ✅ Tayyor  
**Versiya:** 1.0
