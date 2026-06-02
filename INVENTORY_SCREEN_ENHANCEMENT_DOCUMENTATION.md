# Inventory Screen Enhancement - To'liq Hujjat

## 📋 Umumiy Ma'lumot

Inventory (buyumlar) ekrani to'liq yangilandi va quyidagi yangi xususiyatlar qo'shildi:
- Progress bar (zaxira holati ko'rsatkichi)
- Kategoriyalar bo'yicha filter
- Kam zaxira ogohlantirish banneri
- To'ldirish so'rovi funksiyasi
- Oxirgi yangilanish vaqti

## 🎨 Yangi Xususiyatlar

### 1. Progress Bar (Zaxira Holati)

Har bir buyum uchun vizual progress bar ko'rsatiladi:

**Rang Sxemasi**:
- **70%+ (Yashil)**: `#4CAF50` - Zaxira yetarli
- **30-70% (Sariq)**: `#FFA726` - Zaxira o'rtacha
- **30%< (Qizil)**: `#EF5350` - Zaxira kam

**Hisoblash**:
```dart
percentage = quantity / minQuantity
```

**Misol**:
- Quantity: 80, MinQuantity: 100 → 80% (Yashil)
- Quantity: 50, MinQuantity: 100 → 50% (Sariq)
- Quantity: 20, MinQuantity: 100 → 20% (Qizil)

### 2. Kategoriyalar Bo'yicha Filter

4 ta kategoriya:

| Kategoriya | Label | Icon | Backend Value |
|------------|-------|------|---------------|
| Hammasi | Hammasi | `apps_rounded` | `ALL` |
| Hammom | Hammom buyumlari | `bathtub_rounded` | `BATHROOM` |
| Yotoq | Yotoq buyumlari | `bed_rounded` | `BEDROOM` |
| Tozalash | Tozalash vositalari | `cleaning_services_rounded` | `CLEANING` |

**Ishlash Tartibi**:
1. Foydalanuvchi kategoriyani tanlaydi
2. `_selectedCategory` o'zgaradi
3. `_filterItems()` chaqiriladi
4. Faqat tanlangan kategoriya buyumlari ko'rsatiladi

### 3. Kam Zaxira Ogohlantirish

**Banner Ko'rinishi**:
- Sariq gradient fon (`#FFA726` → `#FF9800`)
- Warning icon
- "X ta buyum kam qoldi" xabari
- "Zudlik bilan to'ldirish kerak" matni

**Qachon Ko'rinadi**:
```dart
if (quantity / minQuantity < 0.3) {
  // Kam zaxira
}
```

**Misol**:
- 5 ta buyum 30% dan kam bo'lsa: "5 ta buyum kam qoldi"

### 4. To'ldirish So'rovi

**Dialog Tarkibi**:
- Glassmorphism dizayn
- Hozirgi zaxira va minimum ko'rsatkichi
- Kerakli miqdor input field
- "So'rov yuborish" tugmasi

**API Endpoint**:
```
POST /api/inventory/{id}/request
Body: { "quantity": 50 }
```

**Oqim**:
1. Foydalanuvchi "To'ldirish so'rovi" tugmasini bosadi
2. Dialog ochiladi
3. Kerakli miqdorni kiritadi
4. "So'rov yuborish" tugmasini bosadi
5. Backend ga so'rov yuboriladi
6. Admin ko'radi va tasdiqlaydi
7. Success message ko'rsatiladi

### 5. Oxirgi Yangilanish Vaqti

**Format**:
- Bugun: "Bugun 14:30"
- Kecha: "Kecha"
- 2-6 kun: "3 kun oldin"
- 7+ kun: "15.04.2024"

**Backend Field**:
```json
{
  "lastUpdated": "2024-05-05T14:30:00Z"
}
```

## 🏗️ Arxitektura

### State Management

```dart
class _InventoryScreenState extends State<InventoryScreen> {
  List<dynamic> _allItems = [];        // Barcha buyumlar
  List<dynamic> _filteredItems = [];   // Filtrlangan buyumlar
  bool _loading = true;                // Loading holati
  String _selectedCategory = 'ALL';    // Tanlangan kategoriya
  int _lowStockCount = 0;              // Kam zaxira soni
}
```

### Asosiy Metodlar

#### 1. `_loadInventory()`
```dart
Future<void> _loadInventory() async {
  // API dan buyumlarni yuklash
  // Filtrlash
  // Kam zaxira hisoblash
}
```

#### 2. `_filterItems()`
```dart
void _filterItems() {
  if (_selectedCategory == 'ALL') {
    _filteredItems = _allItems;
  } else {
    _filteredItems = _allItems
        .where((item) => item['category'] == _selectedCategory)
        .toList();
  }
}
```

#### 3. `_calculateLowStock()`
```dart
void _calculateLowStock() {
  _lowStockCount = _allItems.where((item) {
    final qty = item['quantity'] ?? 0;
    final minQty = item['minQuantity'] ?? 0;
    return minQty > 0 && (qty / minQty) < 0.3;
  }).length;
}
```

#### 4. `_getPercentage()`
```dart
double _getPercentage(dynamic item) {
  final qty = (item['quantity'] ?? 0).toDouble();
  final minQty = (item['minQuantity'] ?? 1).toDouble();
  return (qty / minQty).clamp(0.0, 1.0);
}
```

#### 5. `_getProgressColor()`
```dart
Color _getProgressColor(double percentage) {
  if (percentage >= 0.7) return Color(0xFF4CAF50);      // Yashil
  else if (percentage >= 0.3) return Color(0xFFFFA726); // Sariq
  else return Color(0xFFEF5350);                        // Qizil
}
```

#### 6. `_formatDate()`
```dart
String _formatDate(String? dateStr) {
  // DateTime parsing
  // Relative time formatting
  // "Bugun", "Kecha", "X kun oldin", "dd.MM.yyyy"
}
```

#### 7. `_showRefillDialog()`
```dart
Future<void> _showRefillDialog(dynamic item) async {
  // Glassmorphism dialog
  // Current stock info
  // Quantity input
  // Submit button
}
```

#### 8. `_submitRefillRequest()`
```dart
Future<void> _submitRefillRequest(int itemId, int quantity) async {
  // API call
  // Success message
  // Reload inventory
}
```

## 📡 Backend Integration

### API Endpoints

#### 1. Get All Inventory
```
GET /api/inventory
Response: [
  {
    "id": 1,
    "name": "Sochiq",
    "quantity": 80,
    "minQuantity": 100,
    "category": "BATHROOM",
    "lastUpdated": "2024-05-05T14:30:00Z"
  }
]
```

#### 2. Get Low Stock
```
GET /api/inventory/low-stock
Response: [
  {
    "id": 2,
    "name": "Sovun",
    "quantity": 20,
    "minQuantity": 100,
    "category": "BATHROOM",
    "lastUpdated": "2024-05-04T10:00:00Z"
  }
]
```

#### 3. Request Refill
```
POST /api/inventory/{id}/request
Body: {
  "quantity": 50
}
Response: {
  "success": true,
  "message": "Refill request submitted",
  "requestId": 123
}
```

#### 4. Update Inventory (Admin)
```
PATCH /api/inventory/{id}
Body: {
  "quantity": 150
}
Response: {
  "id": 1,
  "name": "Sochiq",
  "quantity": 150,
  "minQuantity": 100
}
```

### Backend Models

#### InventoryItem Entity
```java
@Entity
@Table(name = "inventory_items")
public class InventoryItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private Integer quantity;
    private Integer minQuantity;
    
    @Enumerated(EnumType.STRING)
    private ItemCategory category; // BATHROOM, BEDROOM, CLEANING
    
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
}
```

#### RefillRequest Entity
```java
@Entity
@Table(name = "refill_requests")
public class RefillRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "item_id")
    private InventoryItem item;
    
    @ManyToOne
    @JoinColumn(name = "requested_by")
    private User requestedBy;
    
    private Integer quantity;
    
    @Enumerated(EnumType.STRING)
    private RequestStatus status; // PENDING, APPROVED, REJECTED
    
    @Column(name = "requested_at")
    private LocalDateTime requestedAt;
}
```

## 🎨 Dizayn Tizimi

### Ranglar

| Element | Rang | Hex Code |
|---------|------|----------|
| Yashil (70%+) | Yashil | `#4CAF50` |
| Sariq (30-70%) | To'q sariq | `#FFA726` |
| Qizil (<30%) | Qizil | `#EF5350` |
| Primary | Ko'k | `#1565C0` |
| Warning Banner | Sariq gradient | `#FFA726` → `#FF9800` |

### Typography

- **Font**: Poppins (Google Fonts)
- **Buyum nomi**: 16px, w600
- **Kategoriya**: 12px, w400
- **Progress %**: 12px, w600
- **Oxirgi yangilanish**: 11px, w400

### Spacing

- Card margin: 16px
- Card padding: 16px
- Element spacing: 12px
- Icon size: 24px
- Progress bar height: 8px

### Border Radius

- Card: 16px
- Button: 12px
- Progress bar: 8px
- Category filter: 25px

## 📱 UI Components

### 1. Low Stock Banner
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
    ),
  ),
  child: Row(
    children: [
      Icon(Icons.warning_amber_rounded),
      Text('$_lowStockCount ta buyum kam qoldi'),
    ],
  ),
)
```

### 2. Category Filter
```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: _categories.map((category) {
      return FilterChip(
        label: Text(category['label']),
        icon: Icon(category['icon']),
        selected: _selectedCategory == category['value'],
      );
    }).toList(),
  ),
)
```

### 3. Inventory Card
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(...)],
  ),
  child: Column(
    children: [
      // Header (icon, name, quantity)
      // Progress bar
      // Last updated
      // Refill button
    ],
  ),
)
```

### 4. Refill Dialog
```dart
Dialog(
  backgroundColor: Colors.transparent,
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(...),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Header
          // Current stock info
          // Quantity input
          // Submit button
        ],
      ),
    ),
  ),
)
```

## 🔄 User Flow

### Buyumlarni Ko'rish
```
1. Ekran ochiladi
2. Loading indicator ko'rsatiladi
3. API dan buyumlar yuklanadi
4. Buyumlar ro'yxati ko'rsatiladi
5. Kam zaxira banner (agar bor bo'lsa)
```

### Kategoriya Bo'yicha Filtrlash
```
1. Foydalanuvchi kategoriyani tanlaydi
2. Filter button active bo'ladi
3. Faqat tanlangan kategoriya buyumlari ko'rsatiladi
4. "Hammasi" tanlansa barcha buyumlar ko'rsatiladi
```

### To'ldirish So'rovi Yuborish
```
1. Foydalanuvchi "To'ldirish so'rovi" tugmasini bosadi
2. Glassmorphism dialog ochiladi
3. Hozirgi va minimum zaxira ko'rsatiladi
4. Kerakli miqdorni kiritadi
5. "So'rov yuborish" tugmasini bosadi
6. Validatsiya (miqdor > 0)
7. API ga so'rov yuboriladi
8. Success message ko'rsatiladi
9. Dialog yopiladi
10. Buyumlar ro'yxati yangilanadi
```

## 🧪 Test Qilish

### Manual Testing

1. **Buyumlar Yuklash**
   - Ekranni oching
   - Buyumlar yuklanishini kuting
   - Barcha buyumlar ko'rsatilishini tekshiring

2. **Progress Bar**
   - Har bir buyum uchun progress bar ko'rsatilishini tekshiring
   - Rang to'g'ri ekanligini tekshiring (yashil/sariq/qizil)
   - Foiz to'g'ri hisoblangan ekanligini tekshiring

3. **Kategoriya Filter**
   - Har bir kategoriyani tanlang
   - Faqat tanlangan kategoriya buyumlari ko'rsatilishini tekshiring
   - "Hammasi" tanlanganda barcha buyumlar ko'rsatilishini tekshiring

4. **Kam Zaxira Banner**
   - 30% dan kam buyumlar bo'lsa banner ko'rsatilishini tekshiring
   - Banner da to'g'ri son ko'rsatilishini tekshiring

5. **To'ldirish So'rovi**
   - "To'ldirish so'rovi" tugmasini bosing
   - Dialog ochilishini tekshiring
   - Miqdor kiritib yuboring
   - Success message ko'rsatilishini tekshiring

### API Testing

```bash
# Get all inventory
curl -X GET http://localhost:8080/api/inventory \
  -H "Authorization: Bearer YOUR_TOKEN"

# Request refill
curl -X POST http://localhost:8080/api/inventory/1/request \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"quantity": 50}'
```

## 📊 Performance

### Optimizations

1. **Lazy Loading**: ListView.builder ishlatilgan
2. **Caching**: _allItems va _filteredItems alohida saqlanadi
3. **Efficient Filtering**: O(n) complexity
4. **Pull-to-Refresh**: Faqat kerak bo'lganda yangilanadi

### Memory Usage

- Buyumlar ro'yxati: ~1KB per item
- 100 ta buyum: ~100KB
- Dialog: ~50KB
- Total: ~150KB

## 🐛 Troubleshooting

### Buyumlar Yuklanmaydi

**Sabab**: API xatosi yoki network muammosi

**Yechim**:
1. Backend ishlab turganini tekshiring
2. API endpoint to'g'ri ekanligini tekshiring
3. Token valid ekanligini tekshiring

### Progress Bar Noto'g'ri Rang

**Sabab**: Percentage noto'g'ri hisoblangan

**Yechim**:
```dart
// minQuantity 0 bo'lmasligi kerak
final minQty = (item['minQuantity'] ?? 1).toDouble();
```

### Dialog Ochilmaydi

**Sabab**: Context muammosi

**Yechim**:
```dart
// showDialog da to'g'ri context ishlatish
showDialog(context: context, ...)
```

### Date Format Xatosi

**Sabab**: DateTime parse qila olmaydi

**Yechim**:
```dart
try {
  final date = DateTime.parse(dateStr);
} catch (e) {
  return 'Noma\'lum';
}
```

## 📚 Dependencies

```yaml
dependencies:
  intl: ^0.18.1  # Date formatting
  google_fonts: ^6.1.0  # Poppins font
```

## ✅ Checklist

- [x] Progress bar qo'shildi
- [x] Rang sxemasi (yashil/sariq/qizil)
- [x] Kategoriya filtri
- [x] Kam zaxira banneri
- [x] To'ldirish so'rovi dialogi
- [x] Oxirgi yangilanish vaqti
- [x] API integration
- [x] Glassmorphism dizayn
- [x] Pull-to-refresh
- [x] Error handling
- [x] Loading states
- [x] Success messages

## 🎯 Kelajakdagi Yaxshilanishlar

1. **Search**: Buyum nomi bo'yicha qidirish
2. **Sort**: Nom, miqdor, kategoriya bo'yicha saralash
3. **History**: To'ldirish tarixi
4. **Notifications**: Kam zaxira push notification
5. **Barcode Scanner**: Buyumni barcode bilan qidirish
6. **Export**: Excel/PDF export
7. **Analytics**: Zaxira statistikasi
8. **Predictions**: AI bilan zaxira bashorati
