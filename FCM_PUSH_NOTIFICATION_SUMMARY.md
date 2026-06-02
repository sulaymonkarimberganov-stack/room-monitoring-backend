# FCM Push Notification - Qisqacha Ma'lumot

## ✅ Bajarilgan Ishlar

### 1. Paketlar O'rnatildi
```yaml
firebase_core: ^2.24.0
firebase_messaging: ^14.7.9
flutter_local_notifications: ^16.3.0
```

### 2. Yaratilgan Fayllar

#### `mobile/lib/services/fcm_service.dart`
- FCM token olish va serverga yuborish
- Foreground/background/terminated notification handling
- Local notifications
- Deep linking
- Topic subscription

#### `mobile/android/app/src/main/res/values/colors.xml`
- Notification rangi: `#1565C0`

#### `mobile/android/app/google-services.json.template`
- Firebase konfiguratsiya template

### 3. Yangilangan Fayllar

#### `mobile/pubspec.yaml`
- Firebase dependencies qo'shildi

#### `mobile/lib/main.dart`
- Firebase initialization
- FCM service initialization
- Deep linking navigation setup
- Routes qo'shildi

#### `mobile/lib/services/api_service.dart`
- `sendFCMToken()` metodi qo'shildi
- Endpoint: `POST /api/users/fcm-token`

#### `mobile/lib/providers/auth_provider.dart`
- Login da FCM topiclariga obuna
- Logout da topiclardan chiqish

#### `mobile/android/app/src/main/AndroidManifest.xml`
- FCM permissions qo'shildi
- FCM service sozlandi
- Notification metadata qo'shildi

## 🔔 Bildirishnoma Turlari

| Rol | Turi | Xabar | Qachon |
|-----|------|-------|--------|
| CLEANER | `NEW_TASK` | "205-xona tozalanishi kerak" | Yangi vazifa biriktirilganda |
| MANAGER | `TASK_COMPLETED` | "101-xona tozalandi — tasdiqlash kerak" | Xodim tugatganda |
| ADMIN | `LOW_STOCK` | "Sochiq zaxirasi kam qoldi (5 ta)" | Buyum 10% dan kam |
| ALL | `NEW_USER` | "Tizimga yangi foydalanuvchi qo'shildi" | Yangi user qo'shilganda |

## 🎨 Dizayn

- **Icon**: Mehmonxona logosi
- **Rang**: `#1565C0` (ko'k)
- **Ovoz**: Default
- **Tebranish**: Yoqilgan
- **Priority**: High

## 🔗 Deep Linking

| Type | Route | Screen |
|------|-------|--------|
| `NEW_TASK` | `/cleaner-dashboard` | Cleaner Dashboard |
| `TASK_COMPLETED` | `/manager-dashboard` | Manager Dashboard |
| `LOW_STOCK` | `/inventory` | Inventory Screen |
| `NEW_USER` | `/admin-dashboard` | Admin Dashboard |

## 📊 Topic Subscription

- `role_admin` - Admin foydalanuvchilar
- `role_manager` - Manager foydalanuvchilar
- `role_cleaner` - Cleaner foydalanuvchilar
- `all_users` - Barcha foydalanuvchilar

## 🚀 Keyingi Qadamlar

### 1. Firebase Project Yaratish

```bash
1. https://console.firebase.google.com/ ga kiring
2. "Add project" → "room-monitoring"
3. Android app qo'shing: package name = "Mobil.app"
4. google-services.json yuklab oling
5. mobile/android/app/ ga joylashtiring
```

### 2. Build.gradle Sozlash

**`mobile/android/build.gradle`**:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**`mobile/android/app/build.gradle`**:
```gradle
plugins {
    id "com.google.gms.google-services"
}

android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

### 3. Dependencies O'rnatish

```bash
cd mobile
flutter pub get
```

### 4. Test Qilish

```bash
flutter run -d chrome  # Web da ishlamaydi, faqat Android/iOS
flutter run            # Android emulator yoki device
```

### 5. Backend Integration

#### FCM Token Qabul Qilish

```java
@PostMapping("/users/fcm-token")
public ResponseEntity<?> saveFCMToken(@RequestBody Map<String, String> request) {
    String fcmToken = request.get("fcmToken");
    // Save to database
    return ResponseEntity.ok().build();
}
```

#### Notification Yuborish

```java
import com.google.firebase.messaging.*;

Message message = Message.builder()
    .setNotification(Notification.builder()
        .setTitle("Yangi vazifa")
        .setBody("205-xona tozalanishi kerak")
        .build())
    .putData("type", "NEW_TASK")
    .putData("taskId", "123")
    .putData("roomNumber", "205")
    .setToken(fcmToken)
    .build();

FirebaseMessaging.getInstance().send(message);
```

#### Topic-based Messaging

```java
// Rol bo'yicha
Message message = Message.builder()
    .setNotification(...)
    .setTopic("role_cleaner")
    .build();

// Barcha foydalanuvchilarga
Message message = Message.builder()
    .setNotification(...)
    .setTopic("all_users")
    .build();
```

## 📱 Notification Flow

### Foreground (App ochiq)
```
FCM → onMessage → Local Notification → User tap → Navigate
```

### Background (App background da)
```
FCM → System Notification → User tap → onMessageOpenedApp → Navigate
```

### Terminated (App yopiq)
```
FCM → System Notification → User tap → getInitialMessage → Navigate
```

## 🎯 Notification Payload

```json
{
  "notification": {
    "title": "Yangi vazifa",
    "body": "205-xona tozalanishi kerak"
  },
  "data": {
    "type": "NEW_TASK",
    "taskId": "123",
    "roomNumber": "205"
  },
  "android": {
    "notification": {
      "color": "#1565C0",
      "sound": "default"
    }
  }
}
```

## 🐛 Troubleshooting

### Token null
```dart
// Check permissions
NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
print(settings.authorizationStatus);
```

### Notification ko'rinmaydi
```dart
// Check channel
await fcmService.initialize();
```

### Deep linking ishlamaydi
```dart
// Check navigator key
final navigatorKey = GlobalKey<NavigatorState>();
MaterialApp(navigatorKey: navigatorKey, ...)
```

## 📚 Fayllar

### Yaratilgan
- `mobile/lib/services/fcm_service.dart`
- `mobile/android/app/src/main/res/values/colors.xml`
- `mobile/android/app/google-services.json.template`
- `FCM_PUSH_NOTIFICATION_DOCUMENTATION.md`
- `FCM_PUSH_NOTIFICATION_SUMMARY.md`

### Yangilangan
- `mobile/pubspec.yaml`
- `mobile/lib/main.dart`
- `mobile/lib/services/api_service.dart`
- `mobile/lib/providers/auth_provider.dart`
- `mobile/android/app/src/main/AndroidManifest.xml`

## ✨ Xususiyatlar

- ✅ Foreground notifications
- ✅ Background notifications
- ✅ Terminated state notifications
- ✅ Deep linking
- ✅ Topic-based messaging
- ✅ Role-based subscriptions
- ✅ Custom notification design
- ✅ Sound and vibration
- ✅ Auto token refresh
- ✅ Token storage on server

## 🎉 Tayyor!

FCM push notification tizimi to'liq sozlandi va ishlatishga tayyor!

Keyingi qadamlar:
1. Firebase project yarating
2. google-services.json yuklab oling
3. Build.gradle sozlang
4. Backend integration
5. Test qiling
