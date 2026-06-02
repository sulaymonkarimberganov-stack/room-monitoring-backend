# Custom Widgets Documentation

Professional xato va loading holatlarini boshqarish uchun widgetlar to'plami.

## 📦 Paketlar

```yaml
dependencies:
  lottie: ^3.0.0
  connectivity_plus: ^6.0.0
```

## 🎨 Widgetlar

### 1. CustomLoadingWidget

Yuklanish holatini ko'rsatish uchun.

```dart
// Oddiy loading
CustomLoadingWidget(
  message: 'Yuklanmoqda...',
)

// Lottie animatsiya bilan
CustomLoadingWidget(
  message: 'Ma\'lumotlar yuklanmoqda...',
  showLottie: true,
  size: 80,
)

// Kichik loading (button ichida)
SmallLoadingIndicator(
  color: Colors.white,
  size: 20,
)

// Loading overlay (butun ekranni qoplash)
LoadingOverlay(
  isLoading: _isLoading,
  message: 'Saqlanmoqda...',
  child: YourWidget(),
)
```

### 2. CustomErrorWidget

Xatoliklarni ko'rsatish uchun.

```dart
// Oddiy xato
CustomErrorWidget(
  title: 'Xatolik yuz berdi',
  message: 'Ma\'lumotlarni yuklashda xatolik yuz berdi.',
  onRetry: () {
    // Qayta yuklash logikasi
  },
)

// Network xatosi
NetworkErrorWidget(
  onRetry: () {
    // Internet tekshirish
  },
)

// Server xatosi
ServerErrorWidget(
  errorMessage: '500 Internal Server Error',
  onRetry: () {
    // Qayta ulanish
  },
)
```

### 3. EmptyStateWidget

Bo'sh holatlarni ko'rsatish uchun.

```dart
// Xonalar bo'sh
EmptyRoomsWidget(
  onAddRoom: () {
    // Xona qo'shish
  },
)

// Vazifalar bo'sh
EmptyTasksWidget(
  onAddTask: () {
    // Vazifa qo'shish
  },
)

// Buyumlar bo'sh
EmptyInventoryWidget(
  onAddItem: () {
    // Buyum qo'shish
  },
)

// Qidiruv natijalari bo'sh
EmptySearchWidget(
  searchQuery: 'test',
)

// Bildirishnomalar bo'sh
EmptyNotificationsWidget()

// Custom empty state
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

### 4. CustomSnackBar

Xabarlarni ko'rsatish uchun.

```dart
// Muvaffaqiyat
CustomSnackBar.showSuccess(
  context,
  'Muvaffaqiyatli saqlandi!',
)

// Xato
CustomSnackBar.showError(
  context,
  'Xatolik yuz berdi!',
  onRetry: () {
    // Qayta urinish
  },
)

// Ogohlantirish
CustomSnackBar.showWarning(
  context,
  'Diqqat! Bu muhim xabar.',
)

// Ma'lumot
CustomSnackBar.showInfo(
  context,
  'Ma\'lumot: Yangilanish mavjud.',
)

// Custom
CustomSnackBar.show(
  context,
  message: 'Custom xabar',
  type: SnackBarType.success,
  duration: Duration(seconds: 5),
  actionLabel: 'OK',
  onAction: () {
    // Action
  },
)
```

### 5. ConnectivityService & ConnectivityBanner

Internet aloqasini tekshirish uchun.

```dart
// main.dart da initialize qilish
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  runApp(MyApp());
}

// MaterialApp ni ConnectivityBanner bilan o'rash
MaterialApp(
  home: ConnectivityBanner(
    child: YourHomeScreen(),
  ),
)

// Mixin ishlatish (screen ichida)
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with ConnectivityChecker {
  @override
  void onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      // Internet qayta ulandi
      _refreshData();
    } else {
      // Internet yo'q
      CustomSnackBar.showError(context, 'Internet aloqasi yo\'q');
    }
  }
  
  // isConnected property orqali tekshirish
  void _loadData() {
    if (!isConnected) {
      CustomSnackBar.showError(context, 'Internet aloqasi yo\'q');
      return;
    }
    
    // Ma'lumotlarni yuklash
  }
}
```

## 🎯 Real World Example

```dart
enum LoadingState { idle, loading, success, error, empty }

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with ConnectivityChecker {
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
      // Internet qayta ulandi, qayta yuklash
      _loadRooms();
    }
  }

  Future<void> _loadRooms() async {
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

## 🎨 Ranglar

- **Success**: `#4CAF50` (Yashil)
- **Error**: `#EF5350` (Qizil)
- **Warning**: `#FFA726` (Sariq)
- **Info**: `#1565C0` (Ko'k)

## 📝 Eslatmalar

1. **Lottie animatsiya**: `assets/animations/loading.json` faylini [LottieFiles](https://lottiefiles.com/) dan yuklab oling.

2. **ConnectivityService**: `main.dart` da initialize qilishni unutmang.

3. **SnackBar**: Har doim `context` kerak, shuning uchun `BuildContext` mavjud joyda ishlating.

4. **Loading overlay**: Butun ekranni qoplash kerak bo'lsa `LoadingOverlay` ishlatiladi.

5. **Empty state**: Har bir ekran uchun alohida empty state widget mavjud.

## 🚀 Keyingi qadamlar

- [ ] Lottie animatsiya faylini qo'shish
- [ ] Barcha ekranlarda loading/error/empty holatlarini qo'llash
- [ ] Internet aloqasini tekshirish
- [ ] SnackBar orqali xabarlarni ko'rsatish
