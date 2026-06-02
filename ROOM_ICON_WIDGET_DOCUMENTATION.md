# RoomIconWidget - Xona Ikonka Tizimi

## 📋 Umumiy Ma'lumot

`RoomIconWidget` - bu har xil xona turlari uchun alohida ikonka va rang sxemasini ko'rsatadigan Flutter widget. Xona turi va holatiga qarab avtomatik ravishda to'g'ri ikonka, fon rangi va border rangini tanlaydi.

## 🎨 Xona Turlari va Ikonkalari

### 1. STANDARD (Standart Xona)
- **Ikonka**: `Icons.home_outlined` (uy shakli)
- **Toza holat**:
  - Fon: `rgba(76, 175, 80, 0.15)` - yashil
  - Border: `rgba(76, 175, 80, 0.25)` - yashil
  - Ikonka: `#4CAF50` - yashil
- **Iflos holat**:
  - Fon: `rgba(239, 83, 80, 0.15)` - qizil
  - Border: `rgba(239, 83, 80, 0.25)` - qizil
  - Ikonka: `#EF5350` - qizil
- **Tozalanmoqda holat**:
  - Fon: `rgba(255, 167, 38, 0.15)` - to'q sariq
  - Border: `rgba(255, 167, 38, 0.25)` - to'q sariq
  - Ikonka: `#FFA726` - to'q sariq

### 2. LUXURY (Lyuks Xona)
- **Ikonka**: `Icons.menu_book_outlined` (kitob/ikki qavat)
- **Toza holat**:
  - Fon: `rgba(21, 101, 192, 0.15)` - ko'k
  - Border: `rgba(21, 101, 192, 0.25)` - ko'k
  - Ikonka: `#1565C0` - ko'k
- **Iflos holat**:
  - Fon: `rgba(255, 167, 38, 0.15)` - to'q sariq
  - Border: `rgba(255, 167, 38, 0.25)` - to'q sariq
  - Ikonka: `#FFA726` - to'q sariq
- **Tozalanmoqda holat**:
  - Fon: `rgba(21, 101, 192, 0.1)` - ko'k (ochroq)
  - Border: `rgba(255, 167, 38, 0.3)` - to'q sariq
  - Ikonka: `#1565C0` - ko'k

### 3. SUITE (Suite Xona)
- **Ikonka**: `Icons.star_outline` (yulduz)
- **Toza holat**:
  - Fon: `rgba(94, 53, 177, 0.15)` - binafsha
  - Border: `rgba(255, 215, 0, 0.2)` - oltin
  - Ikonka: `#5E35B1` - binafsha
- **Iflos holat**:
  - Fon: `rgba(239, 83, 80, 0.15)` - qizil
  - Border: `rgba(239, 83, 80, 0.25)` - qizil
  - Ikonka: `#EF5350` - qizil
- **Tozalanmoqda holat**:
  - Fon: `rgba(94, 53, 177, 0.1)` - binafsha (ochroq)
  - Border: `rgba(255, 215, 0, 0.15)` - oltin (ochroq)
  - Ikonka: `#5E35B1` - binafsha

### 4. MAINTENANCE (Ta'mirlash)
- **Ikonka**: `Icons.build_outlined` (kalit)
- **Barcha holatlar uchun**:
  - Fon: `rgba(158, 158, 158, 0.15)` - kulrang
  - Border: `rgba(158, 158, 158, 0.25)` - kulrang
  - Ikonka: `#9E9E9E` - kulrang

## 🔧 Ishlatish

### Asosiy Parametrlar

```dart
RoomIconWidget(
  roomType: 'STANDARD',  // STANDARD, LUXURY, SUITE, MAINTENANCE
  status: 'CLEAN',       // CLEAN, DIRTY, OCCUPIED, CLEANING
  size: 48,              // Ikonka o'lchami (default: 40)
)
```

### Misol 1: Cleaner Dashboard

```dart
RoomIconWidget(
  roomType: roomType,
  status: roomStatus,
  size: 48,
)
```

### Misol 2: Admin Dashboard

```dart
RoomIconWidget(
  roomType: roomType,
  status: status,
  size: 50,
)
```

### Misol 3: Manager Dashboard

```dart
RoomIconWidget(
  roomType: roomType,
  status: status,
  size: 50,
)
```

## 📁 Fayl Joylashuvi

```
mobile/lib/widgets/room_icon_widget.dart
```

## 🎯 Xususiyatlar

1. **Avtomatik Rang Tanlash**: Xona turi va holatiga qarab avtomatik rang sxemasini tanlaydi
2. **Moslashuvchan O'lcham**: `size` parametri orqali ikonka o'lchamini sozlash mumkin
3. **Glassmorphism Dizayn**: Zamonaviy glassmorphism uslubida yaratilgan
4. **Case-Insensitive**: Xona turi va holat katta-kichik harfga bog'liq emas

## 🔄 Holat Mapping

Widget quyidagi holatlarni qo'llab-quvvatlaydi:

- `CLEAN` - Toza xona
- `DIRTY` - Tozalanmagan xona
- `OCCUPIED` - Jarayonda (tozalanmoqda)
- `CLEANING` - Tozalanmoqda (OCCUPIED bilan bir xil)

## 🎨 Dizayn Tizimi

### Border Radius
- Barcha ikonka konteynerlar: `12px`

### Border Width
- Barcha ikonka konteynerlar: `1.5px`

### Ikonka O'lchami
- Default: `40px`
- Ikonka ichidagi icon: `size * 0.5` (50% dan)

## 📝 Yangilanishlar

### Yangilangan Ekranlar

1. **CleanerDashboardScreen** (`mobile/lib/screens/cleaner_dashboard_screen.dart`)
   - Task kartalarida RoomIconWidget ishlatiladi
   - Xona turi va holatiga qarab dinamik ikonka ko'rsatiladi

2. **AdminDashboardScreen** (`mobile/lib/screens/admin_dashboard_screen.dart`)
   - Xona kartalarida RoomIconWidget ishlatiladi
   - Xona turi labeli qo'shildi

3. **ManagerDashboardScreen** (`mobile/lib/screens/manager_dashboard_screen.dart`)
   - Xona kartalarida RoomIconWidget ishlatiladi
   - Xona turi labeli qo'shildi

## 🚀 Kelajakdagi Yaxshilanishlar

1. Animatsiyalar qo'shish (hover, tap)
2. Qo'shimcha xona turlari qo'shish
3. Custom ikonkalar yuklash imkoniyati
4. Rang sxemasini sozlash imkoniyati

## 📞 Qo'llab-quvvatlash

Agar savol yoki muammo bo'lsa, loyiha hujjatlariga murojaat qiling yoki development jamoasiga xabar bering.
