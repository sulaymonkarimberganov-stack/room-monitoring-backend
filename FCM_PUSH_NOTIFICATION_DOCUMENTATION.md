# Firebase Cloud Messaging (FCM) Push Notification - To'liq Hujjat

## 📋 Umumiy Ma'lumot

Flutter ilovangizga Firebase Cloud Messaging (FCM) push notification tizimi muvaffaqiyatli qo'shildi. Bu tizim xodimlar, menejerlar va adminlarga real-time bildirishnomalar yuborish imkonini beradi.

## 🔔 Bildirishnoma Turlari

### 1. Xodimga (CLEANER)
**Turi**: `NEW_TASK`
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
  }
}
```
**Qachon**: Yangi vazifa biriktirilganda

### 2. Menejarga (MANAGER)
**Turi**: `TASK_COMPLETED`
```json
{
  "notification": {
    "title": "Vazifa tugallandi",
    "body": "101-xona tozalandi — tasdiqlash kerak"
  },
  "data": {
    "type": "TASK_COMPLETED",
    "taskId": "124",
    "roomNumber": "101",
    "cleanerId": "5"
  }
}
```
**Qachon**: Xodim vazifani tugatganda

### 3. Adminga (ADMIN)
**Turi**: `LOW_STOCK`
```json
{
  "notification": {
    "title": "Zaxira kam qoldi",
    "body": "Sochiq zaxirasi kam qoldi (5 ta)"
  },
  "data": {
    "type": "LOW_STOCK",
    "itemId": "7",
    "itemName": "Sochiq",
    "quantity": "5"
  }
}
```
**Qachon**: Buyum 10% dan kam qolganda

### 4. Barcha Rollarga
**Turi**: `NEW_USER`
```json
{
  "notification": {
    "title": "Yangi foydalanuvchi",
    "body": "Tizimga yangi foydalanuvchi qo'shildi"
  },
  "data": {
    "type": "NEW_USER",
    "userId": "15",
    "username": "john_doe"
  }
}
```
**Qachon**: Yangi foydalanuvchi qo'shilganda

## 📦 O'rnatilgan Paketlar

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.9
  flutter_local_notifications: ^16.3.0
```

## 🏗️ Arxitektura

### 1. FCMService (`mobile/lib/services/fcm_service.dart`)
- FCM tokenni olish va serverga yuborish
- Foreground, background va terminated holatlarida bildirishnomalarni boshqarish
- Local notifications ko'rsatish
- Deep linking (bildirishnomaga bosilganda to'g'ri ekranga o'tish)
- Topic-based messaging (rol bo'yicha obuna)

### 2. ApiService (`mobile/lib/services/api_service.dart`)
- `sendFCMToken(token)` - FCM tokenni serverga yuborish
- Endpoint: `POST /api/users/fcm-token`

### 3. AuthProvider (`mobile/lib/providers/auth_provider.dart`)
- Login da FCM topiclariga obuna bo'lish
- Logout da barcha topiclardan chiqish

### 4. Main.dart (`mobile/lib/main.dart`)
- Firebase initialization
- FCM service initialization
- Deep linking navigation setup

## 🔧 Sozlash

### 1. Firebase Project Yaratish

1. [Firebase Console](https://console.firebase.google.com/) ga kiring
2. "Add project" tugmasini bosing
3. Project nomini kiriting: `room-monitoring`
4. Google Analytics ni yoqing (ixtiyoriy)
5. Project yaratilishini kuting

### 2. Android App Qo'shish

1. Firebase Console da "Add app" → Android
2. Package name: `Mobil.app`
3. App nickname: `Room Monitoring`
4. Debug signing certificate SHA-1 (ixtiyoriy)
5. "Register app" tugmasini bosing

### 3. google-services.json Yuklab Olish

1. Firebase Console dan `google-services.json` faylini yuklab oling
2. Faylni `mobile/android/app/` papkasiga joylashtiring

```bash
mobile/
  android/
    app/
      google-services.json  ← Bu yerga
```

### 4. Android Build.gradle Sozlash

**`mobile/android/build.gradle`** (project level):
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**`mobile/android/app/build.gradle`** (app level):
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // ← Qo'shing
}

android {
    defaultConfig {
        minSdkVersion 21  // ← 21 yoki yuqori bo'lishi kerak
    }
}
```

### 5. AndroidManifest.xml

Allaqachon sozlangan! Quyidagi ruxsatlar qo'shilgan:
- `POST_NOTIFICATIONS` - Android 13+ uchun
- `VIBRATE` - Tebranish
- FCM service va metadata

### 6. iOS Sozlash (Ixtiyoriy)

**`mobile/ios/Runner/Info.plist`**:
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

## 🚀 Ishlatish

### Backend Tarafida

#### 1. FCM Token Qabul Qilish

```java
@PostMapping("/users/fcm-token")
public ResponseEntity<?> saveFCMToken(@RequestBody Map<String, String> request) {
    String fcmToken = request.get("fcmToken");
    // Token ni database ga saqlash
    // User ID bilan bog'lash
    return ResponseEntity.ok().build();
}
```

#### 2. Bildirishnoma Yuborish (Java/Spring Boot)

```java
import com.google.firebase.messaging.*;

public void sendNotificationToUser(String fcmToken, String title, String body, Map<String, String> data) {
    Message message = Message.builder()
        .setNotification(Notification.builder()
            .setTitle(title)
            .setBody(body)
            .build())
        .putAllData(data)
        .setToken(fcmToken)
        .setAndroidConfig(AndroidConfig.builder()
            .setNotification(AndroidNotification.builder()
                .setColor("#1565C0")
                .setSound("default")
                .build())
            .build())
        .build();
    
    try {
        String response = FirebaseMessaging.getInstance().send(message);
        System.out.println("Successfully sent message: " + response);
    } catch (FirebaseMessagingException e) {
        e.printStackTrace();
    }
}
```

#### 3. Topic-based Messaging

```java
// Rol bo'yicha yuborish
public void sendToRole(String role, String title, String body) {
    Message message = Message.builder()
        .setNotification(Notification.builder()
            .setTitle(title)
            .setBody(body)
            .build())
        .setTopic("role_" + role.toLowerCase())
        .build();
    
    FirebaseMessaging.getInstance().send(message);
}

// Barcha foydalanuvchilarga
public void sendToAllUsers(String title, String body) {
    Message message = Message.builder()
        .setNotification(Notification.builder()
            .setTitle(title)
            .setBody(body)
            .build())
        .setTopic("all_users")
        .build();
    
    FirebaseMessaging.getInstance().send(message);
}
```

### Frontend Tarafida

#### 1. FCM Token Olish

```dart
final fcmService = FCMService();
await fcmService.initialize();
String? token = fcmService.fcmToken;
print('FCM Token: $token');
```

#### 2. Bildirishnomaga Bosilganda

```dart
fcmService.onNotificationTap = (route, data) {
  // Navigate to specific screen
  navigatorKey.currentState?.pushNamed(route, arguments: data);
};
```

## 🎨 Dizayn

### Notification Appearance

- **Icon**: Mehmonxona logosi (`@mipmap/ic_launcher`)
- **Rang**: `#1565C0` (ko'k)
- **Ovoz**: Default Android notification sound
- **Tebranish**: Yoqilgan
- **Priority**: High
- **Channel**: `room_monitoring_channel`

### Notification States

1. **Foreground**: Local notification ko'rsatiladi
2. **Background**: FCM notification avtomatik ko'rsatiladi
3. **Terminated**: FCM notification avtomatik ko'rsatiladi

## 🔗 Deep Linking

Bildirishnomaga bosilganda to'g'ri ekranga o'tish:

| Type | Route | Screen |
|------|-------|--------|
| `NEW_TASK` | `/cleaner-dashboard` | Cleaner Dashboard |
| `TASK_COMPLETED` | `/manager-dashboard` | Manager Dashboard |
| `LOW_STOCK` | `/inventory` | Inventory Screen |
| `NEW_USER` | `/admin-dashboard` | Admin Dashboard |

## 📱 Test Qilish

### 1. Firebase Console orqali

1. Firebase Console → Cloud Messaging
2. "Send your first message"
3. Notification title va body kiriting
4. "Send test message"
5. FCM token ni kiriting
6. "Test" tugmasini bosing

### 2. Postman orqali

```bash
POST https://fcm.googleapis.com/fcm/send
Headers:
  Authorization: key=YOUR_SERVER_KEY
  Content-Type: application/json

Body:
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Test Notification",
    "body": "Bu test bildirishnomasi"
  },
  "data": {
    "type": "NEW_TASK",
    "taskId": "123"
  }
}
```

### 3. Flutter App ichida

```dart
// Debug mode da token ni console ga chiqarish
final fcmService = FCMService();
print('FCM Token: ${fcmService.fcmToken}');
```

## 🐛 Muammolarni Hal Qilish

### 1. Token null qaytaradi

**Sabab**: Firebase sozlanmagan yoki ruxsat berilmagan

**Yechim**:
- `google-services.json` faylini tekshiring
- AndroidManifest.xml da ruxsatlarni tekshiring
- App ni qayta o'rnating

### 2. Notification ko'rinmaydi

**Sabab**: Notification channel yaratilmagan

**Yechim**:
```dart
await fcmService.initialize(); // Bu channel yaratadi
```

### 3. Background notification ishlamaydi

**Sabab**: Background handler sozlanmagan

**Yechim**:
```dart
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```

### 4. Deep linking ishlamaydi

**Sabab**: Navigation key sozlanmagan

**Yechim**:
```dart
final navigatorKey = GlobalKey<NavigatorState>();
MaterialApp(navigatorKey: navigatorKey, ...)
```

## 📊 Topic Subscription

### Rol bo'yicha

- `role_admin` - Admin foydalanuvchilar
- `role_manager` - Manager foydalanuvchilar
- `role_cleaner` - Cleaner foydalanuvchilar
- `all_users` - Barcha foydalanuvchilar

### Obuna bo'lish

```dart
await fcmService.subscribeToTopic('role_admin');
await fcmService.subscribeToTopic('all_users');
```

### Obunadan chiqish

```dart
await fcmService.unsubscribeFromTopic('role_admin');
await fcmService.unsubscribeFromAllTopics();
```

## 🔒 Xavfsizlik

1. **Server Key**: Server key ni frontend da ishlatmang
2. **Token Storage**: FCM token ni xavfsiz saqlang
3. **Validation**: Backend da token validatsiyasini amalga oshiring
4. **Rate Limiting**: Spam oldini olish uchun rate limiting qo'shing

## 📈 Monitoring

Firebase Console da quyidagilarni kuzatish mumkin:

- Yuborilgan bildirishnomalar soni
- Ochilgan bildirishnomalar soni
- Conversion rate
- Error logs

## 🎯 Best Practices

1. **Personalization**: Foydalanuvchi nomini ishlatish
2. **Timing**: To'g'ri vaqtda yuborish (ish vaqtida)
3. **Relevance**: Faqat tegishli bildirishnomalar
4. **Frequency**: Juda ko'p yubormaslik
5. **Action**: Har bir bildirishnomada aniq action

## 📚 Qo'shimcha Resurslar

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Messaging Plugin](https://pub.dev/packages/firebase_messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

## ✅ Checklist

- [x] Firebase project yaratildi
- [x] Android app qo'shildi
- [x] google-services.json yuklab olindi
- [x] Dependencies qo'shildi
- [x] FCMService yaratildi
- [x] AndroidManifest.xml sozlandi
- [x] Deep linking sozlandi
- [x] Topic subscription qo'shildi
- [ ] Backend FCM integration
- [ ] Production testing
