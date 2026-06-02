# FCM Setup Guide - Bosqichma-bosqich Qo'llanma

## 🎯 Maqsad

Bu qo'llanma Flutter ilovangizga Firebase Cloud Messaging (FCM) push notification tizimini to'liq sozlash uchun barcha bosqichlarni tushuntiradi.

## ✅ Tayyor Bo'lgan Narsalar

- ✅ Flutter code (FCMService, API integration)
- ✅ AndroidManifest.xml sozlamalari
- ✅ Dependencies (pubspec.yaml)
- ✅ Deep linking
- ✅ Topic subscription

## 🚀 Qolgan Ishlar

### 1. Firebase Project Yaratish (5 daqiqa)

1. **Firebase Console ga kiring**
   - https://console.firebase.google.com/
   - Google account bilan login qiling

2. **Yangi project yarating**
   - "Add project" tugmasini bosing
   - Project nomi: `room-monitoring`
   - Google Analytics: Yoqing (ixtiyoriy)
   - "Create project" tugmasini bosing
   - 30-60 soniya kutib turing

3. **Project yaratildi!** ✅

### 2. Android App Qo'shish (3 daqiqa)

1. **Firebase Console da**
   - Project overview → "Add app" → Android icon

2. **App ma'lumotlarini kiriting**
   ```
   Android package name: Mobil.app
   App nickname: Room Monitoring
   Debug signing certificate SHA-1: (ixtiyoriy)
   ```

3. **"Register app" tugmasini bosing**

### 3. google-services.json Yuklab Olish (1 daqiqa)

1. **Download google-services.json**
   - Firebase Console da "Download google-services.json" tugmasini bosing

2. **Faylni joylashtiring**
   ```
   mobile/
     android/
       app/
         google-services.json  ← Bu yerga
   ```

3. **Tekshirish**
   ```bash
   ls mobile/android/app/google-services.json
   ```

### 4. Build.gradle Sozlash (5 daqiqa)

#### A. Project level build.gradle

**Fayl**: `mobile/android/build.gradle`

```gradle
buildscript {
    ext.kotlin_version = '1.9.0'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.4.0'  // ← Qo'shing
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

#### B. App level build.gradle

**Fayl**: `mobile/android/app/build.gradle`

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // ← Qo'shing
}

android {
    namespace "Mobil.app"
    compileSdkVersion 34

    defaultConfig {
        applicationId "Mobil.app"
        minSdkVersion 21  // ← 21 yoki yuqori
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
        multiDexEnabled true  // ← Qo'shing
    }
}
```

### 5. Dependencies O'rnatish (2 daqiqa)

```bash
cd mobile
flutter pub get
```

**Kutilayotgan natija**:
```
Running "flutter pub get" in mobile...
Resolving dependencies...
+ firebase_core 2.24.0
+ firebase_messaging 14.7.9
+ flutter_local_notifications 16.3.0
Changed 15 dependencies!
```

### 6. Backend Sozlash (15 daqiqa)

#### A. Firebase Admin SDK

**pom.xml**:
```xml
<dependency>
    <groupId>com.google.firebase</groupId>
    <artifactId>firebase-admin</artifactId>
    <version>9.2.0</version>
</dependency>
```

#### B. Service Account Key

1. Firebase Console → Project Settings → Service Accounts
2. "Generate new private key" tugmasini bosing
3. `firebase-service-account.json` faylini yuklab oling
4. `src/main/resources/` ga joylashtiring

#### C. Firebase Config

`FirebaseConfig.java` yarating (FCM_BACKEND_EXAMPLES.md ga qarang)

#### D. FCM Service

`FCMService.java` yarating (FCM_BACKEND_EXAMPLES.md ga qarang)

#### E. User Entity

`User` entity ga `fcmToken` field qo'shing:
```java
@Column(length = 500)
private String fcmToken;
```

#### F. Database Migration

```sql
ALTER TABLE users ADD COLUMN fcm_token VARCHAR(500);
```

#### G. API Endpoint

`UserController.java` ga FCM token endpoint qo'shing:
```java
@PostMapping("/users/fcm-token")
public ResponseEntity<?> saveFCMToken(@RequestBody Map<String, String> request, Authentication auth) {
    // Implementation
}
```

### 7. Test Qilish (10 daqiqa)

#### A. Flutter App Run

```bash
cd mobile
flutter run
```

#### B. FCM Token Olish

App console da token ko'rinadi:
```
FCM Token: dXYz123...
```

Token ni copy qiling.

#### C. Firebase Console Test

1. Firebase Console → Cloud Messaging
2. "Send your first message"
3. Notification title: "Test"
4. Notification text: "Bu test"
5. "Send test message"
6. FCM token ni paste qiling
7. "Test" tugmasini bosing

#### D. Notification Ko'rinishi

- ✅ Notification keldi
- ✅ Title va body to'g'ri
- ✅ Icon ko'k rang
- ✅ Ovoz eshitildi
- ✅ Bosilganda app ochildi

### 8. Backend Test (5 daqiqa)

#### A. Postman

```bash
POST http://localhost:8080/api/notifications/send-test
Headers:
  Authorization: Bearer YOUR_JWT_TOKEN
  Content-Type: application/json

Body:
{
  "fcmToken": "YOUR_FCM_TOKEN",
  "title": "Backend Test",
  "body": "Bu backend dan yuborildi"
}
```

#### B. Kutilayotgan Natija

```json
{
  "success": true,
  "messageId": "projects/room-monitoring/messages/0:1234567890"
}
```

### 9. Production Deploy (10 daqiqa)

#### A. APK Build

```bash
cd mobile
flutter build apk --release --no-tree-shake-icons
```

#### B. APK Test

```bash
adb install mobile/build/app/outputs/flutter-apk/app-release.apk
```

#### C. Backend Deploy

```bash
cd app
mvn clean package
java -jar target/app-0.0.1-SNAPSHOT.jar
```

#### D. Production Test

1. Login qiling
2. FCM token serverga yuborilishini tekshiring
3. Backend dan notification yuboring
4. Notification kelishini tekshiring

## 🎉 Tayyor!

FCM push notification tizimi to'liq sozlandi va ishlamoqda!

## 📊 Monitoring

### Firebase Console

1. Cloud Messaging → Reports
2. Ko'rish mumkin:
   - Yuborilgan notifications
   - Ochilgan notifications
   - Conversion rate
   - Error logs

### Backend Logs

```java
System.out.println("FCM token saved: " + fcmToken);
System.out.println("Notification sent: " + messageId);
```

## 🐛 Troubleshooting

### Token null

**Sabab**: Firebase sozlanmagan

**Yechim**:
1. `google-services.json` mavjudligini tekshiring
2. Build.gradle da plugin qo'shilganini tekshiring
3. App ni qayta o'rnating

### Notification kelmaydi

**Sabab**: Permission berilmagan

**Yechim**:
1. App Settings → Notifications → Yoqing
2. App ni qayta ishga tushiring

### Backend error

**Sabab**: Service account key noto'g'ri

**Yechim**:
1. `firebase-service-account.json` ni qayta yuklab oling
2. `src/main/resources/` da ekanligini tekshiring

## 📚 Keyingi Qadamlar

1. ✅ Production da test qiling
2. ✅ Barcha notification turlarini test qiling
3. ✅ Error handling qo'shing
4. ✅ Logging qo'shing
5. ✅ Monitoring sozlang
6. ✅ Rate limiting qo'shing

## 🎯 Checklist

- [ ] Firebase project yaratildi
- [ ] Android app qo'shildi
- [ ] google-services.json yuklab olindi va joylashtrildi
- [ ] Build.gradle sozlandi
- [ ] Dependencies o'rnatildi
- [ ] Backend Firebase Admin SDK qo'shildi
- [ ] Service account key yuklab olindi
- [ ] FCMService yaratildi
- [ ] User entity yangilandi
- [ ] API endpoint yaratildi
- [ ] Flutter app test qilindi
- [ ] Backend test qilindi
- [ ] Production deploy qilindi
- [ ] Monitoring sozlandi

## 💡 Tips

1. **Development**: Firebase Console test message ishlatish
2. **Testing**: Postman collection yaratish
3. **Production**: Error handling va logging qo'shish
4. **Monitoring**: Firebase Analytics yoqish
5. **Security**: Rate limiting qo'shish

## 📞 Yordam

Agar muammo bo'lsa:
1. `FCM_PUSH_NOTIFICATION_DOCUMENTATION.md` ni o'qing
2. `FCM_BACKEND_EXAMPLES.md` ga qarang
3. Firebase Console logs ni tekshiring
4. Backend logs ni tekshiring
