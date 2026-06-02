# 🚀 RENDER.COM GA DEPLOY QILISH QO'LLANMASI

## 📋 BOSQICHLAR:

### 1. RENDER.COM GA KIRISH
- https://render.com
- GitHub bilan Sign Up/Login

### 2. POSTGRESQL DATABASE YARATISH
1. Dashboard → "New +" → "PostgreSQL"
2. Settings:
   - Name: `room-monitoring-db`
   - Database: `room_monitoring`
   - Region: Frankfurt (Europe) yoki Oregon (US)
   - Plan: **Free** ✅
3. "Create Database" bosing
4. **Internal Database URL** ni nusxalang (masalan):
   ```
   postgresql://user:password@dpg-xxxxx-a.frankfurt-postgres.render.com/room_monitoring_db
   ```

### 3. BACKEND WEB SERVICE YARATISH
1. Dashboard → "New +" → "Web Service"
2. "Build and deploy from a Git repository"
3. GitHub repo URL yoki Public Git URL kiriting
4. Settings:
   - **Name:** `room-monitoring-backend`
   - **Region:** Database bilan bir xil (Frankfurt)
   - **Branch:** `main`
   - **Root Directory:** `app`
   - **Runtime:** Java
   - **Build Command:**
     ```bash
     mvn clean package -DskipTests
     ```
   - **Start Command:**
     ```bash
     java -jar target/app-0.0.1-SNAPSHOT.jar
     ```
   - **Instance Type:** Free

5. **Environment Variables:**
   ```
   DATABASE_URL = [2-qadamda nusxalagan URL]
   PORT = 8080
   JWT_SECRET = room-monitoring-secret-key-for-jwt-token-generation-minimum-256-bits
   ```

6. "Create Web Service" bosing

### 4. DEPLOY KUTISH
- Deploy 5-10 daqiqa davom etadi
- Logs da quyidagilarni ko'ring:
  ```
  Started AppApplication in X seconds
  ```
- Tayyor URL: `https://room-monitoring-backend-XXXX.onrender.com`

### 5. TEKSHIRISH
Browserda oching:
```
https://room-monitoring-backend-XXXX.onrender.com/actuator/health
```

Natija:
```json
{"status":"UP"}
```

### 6. FLUTTER ILOVASINI YANGILASH

`mobile/lib/services/api_service.dart` faylida:

```dart
static const String baseUrl = 'https://room-monitoring-backend-XXXX.onrender.com/api';
```

### 7. YANGI APK BUILD QILISH

```bash
cd mobile
flutter clean
flutter build apk --release
```

APK joyi:
```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

---

## ⚠️ RENDER.COM BEPUL REJASI:

✅ **Yaxshi tomonlari:**
- To'liq bepul
- PostgreSQL database
- 750 soat/oy (31 kun)
- Avtomatik HTTPS
- Git push bilan avtomatik deploy

❌ **Cheklovlar:**
- 15 daqiqa ishlatilmasa "sleep" rejimiga o'tadi
- Birinchi request 30-60 soniya kutadi (cold start)
- 512 MB RAM

💡 **Yechim:** Har 10 daqiqada ping qilish (cron job):
- https://cron-job.org
- Har 10 daqiqada: `https://YOUR-URL.onrender.com/actuator/health`

---

## 🆘 MUAMMOLAR:

### Database ulanmayapti:
1. Render dashboard → PostgreSQL → Connections
2. "Internal Database URL" ni nusxalang
3. Backend Environment Variables da yangilang

### Build xatosi:
1. Logs ni tekshiring
2. Java version: 21
3. Maven version: 3.8+

### 502 Bad Gateway:
1. Backend "sleep" rejimida
2. 30-60 soniya kuting
3. Sahifani yangilang

---

## 📞 YORDAM:

Agar muammo bo'lsa:
1. Render Logs ni tekshiring
2. Database connection string to'g'ri ekanligini tasdiqlang
3. Environment variables to'liq ekanligini tekshiring

---

**MUVAFFAQIYAT! 🎉**
