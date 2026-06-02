# Custom Widgets - Professional Loading & Error States

Flutter ilovasi uchun professional xato va loading holatlarini boshqarish tizimi.

## ✅ Yaratilgan Widgetlar

### 📁 Fayl Strukturasi

```
mobile/lib/core/
├── widgets/
│   ├── custom_loading_widget.dart      # Loading holatlar
│   ├── custom_error_widget.dart        # Xato holatlar
│   ├── empty_state_widget.dart         # Bo'sh holatlar
│   ├── custom_snackbar.dart            # Xabarlar
│   ├── widgets.dart                    # Export fayli
│   ├── widgets_demo.dart               # Ishlatish misollari
│   └── README.md                       # To'liq dokumentatsiya
├── services/
│   └── connectivity_service.dart       # Internet tekshiruvi
└── theme/
    └── app_theme.dart                  # Yagona tema
```

## 📦 O'rnatilgan Paketlar

```yaml
dependencies:
  lottie: ^3.0.0              # Animatsiyalar uchun
  connectivity_plus: ^6.0.0   # Internet tekshiruvi uchun
```

## 🎨 1. CustomLoadingWidget

**3 xil loading varianti:**

### a) Oddiy Loading
```dart
CustomLoadingWidget(
  message: 'Yuklanmoqda...',
)
```

### b) Lottie Animatsiya bilan
```dart
CustomLoadingWidget(
  message: 'Ma\'lumotlar yuklanmoqda...',
  showLottie: true,
  size: 80,
)
```

### c) Kichik Loading (Button ichida)
```dart
ElevatedButton(
  onPressed: _isLoading ? null : _submit,
  child: _isLoading
      ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmallLoadingIndicator(),
            SizedBox(width: 8),
            Text('Yuklanmoqda...'),
          ],
        )
      : Text('Saqlash'),
)
```

### d) Loading Overlay (Butun ekranni qoplash)
```dart
LoadingOverlay(
  isLoading: _isLoading,
  message: 'Saqlanmoqda...',
  child: YourWidget(),
)
```

**Xususiyatlar:**
- ✅ Pulsating circle animatsiya (#1565C0 → #5E35B1)
- ✅ Gradient rang o'zgarishi
- ✅ Shadow effekt
- ✅ Lottie animatsiya qo'llab-quvvatlash
- ✅ Kichik va katta variantlar

---

## ❌ 2. CustomErrorWidget

**3 xil error varianti:**

### a) Oddiy Xato
```dart
CustomErrorWidget(
  title: 'Xatolik yuz berdi',
  message: 'Ma\'lumotlarni yuklashda xatolik yuz berdi.',
  onRetry: () {
    _loadData();
  },
)
```

### b) Network Xatosi
```dart
NetworkErrorWidget(
  onRetry: () {
    _checkConnection();
  },
)
```

### c) Server Xatosi
```dart
ServerErrorWidget(
  errorMessage: '500 Internal Server Error',
  onRetry: () {
    _reconnect();
  },
)
```

**Xususiyatlar:**
- ✅ Qizil rang (#EF5350)
- ✅ Animatsiyali ikonka (elasticOut curve)
- ✅ "Qayta urinish" tugmasi
- ✅ Custom icon qo'llab-quvvatlash

---

## 📭 3. EmptyStateWidget

**6 xil empty state varianti:**

### a) Bo'sh Xonalar
```dart
EmptyRoomsWidget(
  onAddRoom: () {
    // Xona qo'shish
  },
)
```

### b) Bo'sh Vazifalar
```dart
EmptyTasksWidget(
  onAddTask: () {
    // Vazifa qo'shish
  },
)
```

### c) Bo'sh Buyumlar
```dart
EmptyInventoryWidget(
  onAddItem: () {
    // Buyum qo'shish
  },
)
```

### d) Bo'sh Qidiruv
```dart
EmptySearchWidget(
  searchQuery: 'test',
)
```

### e) Bo'sh Bildirishnomalar
```dart
EmptyNotificationsWidget()
```

### f) Custom Empty State
```dart
EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'Hech narsa topilmadi',
  description: 'Bu yerda hozircha ma\'lumot yo\'q.',
  actionText: 'Qo\'shish',
  onAction: () {
    // Action
  },
)
```

**Xususiyatlar:**
- ✅ Gradient circle background
- ✅ Animatsiyali ikonka (easeOutBack curve)
- ✅ Har ekran uchun alohida widget
- ✅ Action button (ixtiyoriy)

---

## 💬 4. CustomSnackBar

**4 xil snackbar varianti:**

### a) Success (Yashil)
```dart
CustomSnackBar.showSuccess(
  context,
  'Muvaffaqiyatli saqlandi!',
)
```

### b) Error (Qizil)
```dart
CustomSnackBar.showError(
  context,
  'Xatolik yuz berdi!',
  onRetry: () {
    _retry();
  },
)
```

### c) Warning (Sariq)
```dart
CustomSnackBar.showWarning(
  context,
  'Diqqat! Bu muhim xabar.',
)
```

### d) Info (Ko'k)
```dart
CustomSnackBar.showInfo(
  context,
  'Ma\'lumot: Yangilanish mavjud.',
)
```

**Ranglar:**
- 🟢 Success: `#4CAF50` (Yashil)
- 🔴 Error: `#EF5350` (Qizil)
- 🟡 Warning: `#FFA726` (Sariq)
- 🔵 Info: `#1565C0` (Ko'k)

**Xususiyatlar:**
- ✅ Floating behavior
- ✅ Rounded corners (12px)
- ✅ Icon bilan
- ✅ Action button qo'llab-quvvatlash
- ✅ Auto-dismiss

---

## 🌐 5. ConnectivityService & ConnectivityBanner

### a) Initialize (main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Connectivity Service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  runApp(MyApp());
}
```

### b) MaterialApp ni o'rash
```dart
MaterialApp(
  home: ConnectivityBanner(
    child: YourHomeScreen(),
  ),
)
```

### c) Mixin ishlatish (Screen ichida)
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with ConnectivityChecker {
  @override
  void onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      // Internet qayta ulandi
      CustomSnackBar.showSuccess(context, 'Internet qayta ulandi');
      _refreshData();
    } else {
      // Internet yo'q
      CustomSnackBar.showError(context, 'Internet aloqasi yo\'q');
    }
  }
  
  void _loadData() {
    if (!isConnected) {
      CustomSnackBar.showError(context, 'Internet aloqasi yo\'q');
      return;
    }
    
    // Ma'lumotlarni yuklash
  }
}
```

**Xususiyatlar:**
- ✅ Real-time internet tekshiruvi
- ✅ Avtomatik banner ko'rsatish
- ✅ Yashil banner (qayta ulanganda)
- ✅ Qizil banner (internet yo'q)
- ✅ "Tekshirish" tugmasi
- ✅ Mixin orqali oson integratsiya

---

## 🎯 Real World Example

```dart
enum LoadingState { idle, loading, success, error, empty }

class RoomsScreen extends StatefulWidget {
  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> with ConnectivityChecker {
  LoadingState _state = LoadingState.idle;
  List<Room> _rooms = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  void onConnectivityChanged(bool isConnected) {
    if (isConnected && _state == LoadingState.error) {
      CustomSnackBar.showSuccess(context, 'Internet qayta ulandi');
      _loadRooms();
    }
  }

  Future<void> _loadRooms() async {
    // Internet tekshiruvi
    if (!isConnected) {
      setState(() {
        _state = LoadingState.error;
        _errorMessage = 'Internet aloqasi yo\'q';
      });
      return;
    }

    setState(() => _state = LoadingState.loading);

    try {
      final rooms = await apiService.getRooms();
      
      setState(() {
        _rooms = rooms;
        _state = rooms.isEmpty ? LoadingState.empty : LoadingState.success;
      });
      
      CustomSnackBar.showSuccess(context, 'Ma\'lumotlar yuklandi');
    } catch (e) {
      setState(() {
        _state = LoadingState.error;
        _errorMessage = e.toString();
      });
      
      CustomSnackBar.showError(
        context,
        'Xatolik: ${e.toString()}',
        onRetry: _loadRooms,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Xonalar')),
      body: _buildBody(),
      floatingActionButton: _state == LoadingState.success
          ? FloatingActionButton(
              onPressed: _addRoom,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadingState.idle:
      case LoadingState.loading:
        return CustomLoadingWidget(
          message: 'Xonalar yuklanmoqda...',
        );

      case LoadingState.error:
        return isConnected
            ? CustomErrorWidget(
                message: _errorMessage,
                onRetry: _loadRooms,
              )
            : NetworkErrorWidget(
                onRetry: _loadRooms,
              );

      case LoadingState.empty:
        return EmptyRoomsWidget(
          onAddRoom: _addRoom,
        );

      case LoadingState.success:
        return RefreshIndicator(
          onRefresh: _loadRooms,
          child: ListView.builder(
            itemCount: _rooms.length,
            itemBuilder: (context, index) {
              return RoomCard(room: _rooms[index]);
            },
          ),
        );
    }
  }

  void _addRoom() {
    // Xona qo'shish logikasi
  }
}
```

---

## 📝 Import Qilish

```dart
// Barcha widgetlarni import qilish
import 'package:room_monitoring/core/widgets/widgets.dart';

// Connectivity service
import 'package:room_monitoring/core/services/connectivity_service.dart';
```

---

## 🎨 Dizayn Xususiyatlari

### Ranglar
- **Primary**: `#1565C0` (Ko'k)
- **Secondary**: `#5E35B1` (Binafsha)
- **Success**: `#4CAF50` (Yashil)
- **Error**: `#EF5350` (Qizil)
- **Warning**: `#FFA726` (Sariq)
- **Background**: `#0A0E1A` (Qora)

### Animatsiyalar
- **Loading**: Pulsating + Gradient (1500ms)
- **Error Icon**: ElasticOut (600ms)
- **Empty Icon**: EaseOutBack (800ms)
- **Banner**: Slide from top (300ms)

### Border Radius
- **Cards**: 16px
- **Buttons**: 12-14px
- **SnackBar**: 12px
- **Dialogs**: 20px

---

## 🚀 Keyingi Qadamlar

1. ✅ Barcha widgetlar yaratildi
2. ✅ ConnectivityService integratsiya qilindi
3. ✅ main.dart da initialize qilindi
4. ⏳ Lottie animatsiya faylini qo'shish (ixtiyoriy)
5. ⏳ Barcha ekranlarda loading/error/empty holatlarini qo'llash

---

## 📚 To'liq Dokumentatsiya

To'liq dokumentatsiya va ko'proq misollar uchun:
- `mobile/lib/core/widgets/README.md`
- `mobile/lib/core/widgets/widgets_demo.dart`

---

## ✨ Xususiyatlar

- ✅ Professional dizayn
- ✅ Smooth animatsiyalar
- ✅ Dark theme mos
- ✅ Glassmorphism uslubi
- ✅ Responsive
- ✅ Oson ishlatish
- ✅ To'liq dokumentatsiya
- ✅ Real-time internet tekshiruvi
- ✅ Avtomatik reconnect
- ✅ Lottie qo'llab-quvvatlash

---

**Yaratilgan sana**: 2026-05-05  
**Versiya**: 1.0.0  
**Status**: ✅ Tayyor
