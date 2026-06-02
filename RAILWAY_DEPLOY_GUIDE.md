# 🚂 RAILWAY.APP GA DEPLOY QILISH QO'LLANMASI

## 📋 BOSQICHLAR:

### 1. RAILWAY.APP GA KIRISH
1. https://railway.app ga o'ting
2. **"Login"** bosing
3. **GitHub** yoki **Email** bilan kirish
4. Yangi akkaunt uchun email tasdiqlang

---

### 2. YANGI PROJECT YARATISH

#### A. GitHub Repository ulanish (TAVSIYA QILINADI)
1. Railway dashboard → **"New Project"**
2. **"Deploy from GitHub repo"** tanlang
3. GitHub akkauntingizni ulang
4. Repository'ni tanlang (room-monitoring yoki sizning repo nomingiz)
5. **"Deploy Now"** bosing

#### B. Yoki Empty Project
1. Railway dashboard → **"New Project"**
2. **"Deploy from GitHub repo"** yoki **"Empty Project"**

---

### 3. POSTGRESQL DATABASE QO'SHISH

1. Ochilgan project ichida → **"+ New"** → **"Database"** → **"PostgreSQL"**
2. Database avtomatik yaratiladi va environment variables qo'shiladi:
   - `DATABASE_URL`
   - `DATABASE_PUBLIC_URL` (tashqi ulanish uchun)
   - `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`

3. Database **Settings** → **Connect** da ulanish ma'lumotlarini ko'ring

---

### 4. BACKEND SERVICE SOZLASH

#### GitHub orqali deploy qilgan bo'lsangiz:
Railway avtomatik detect qiladi va build qiladi.

#### Manual sozlash:
1. Service → **Settings**
2. **Build & Deploy** bo'limida:
   - **Root Directory**: `app`
   - **Build Command**:
     ```bash
     mvn clean package -DskipTests
     ```
   - **Start Command**:
     ```bash
     java -jar target/app-0.0.1-SNAPSHOT.jar
     ```

---

### 5. ENVIRONMENT VARIABLES QO'SHISH

Service → **Variables** bo'limida quyidagilarni qo'shing:

```
DATABASE_URL = postgresql://postgres:password@postgres.railway.internal:5432/railway
PORT = 8080
JWT_SECRET = room-monitoring-secret-key-for-jwt-token-generation-minimum-256-bits
```

**MUHIM:** `DATABASE_URL` avtomatik qo'shiladi PostgreSQL database qo'shganda. Agar yo'q bo'lsa, qo'lda qo'shing.

---

### 6. DEPLOY QILISH

1. GitHub'dan deploy qilgan bo'lsangiz, avtomatik deploy boshlanadi
2. Yoki **"Deploy"** tugmasini bosing
3. **Logs** ni kuzating:
   ```
   Building...
   Installing Maven...
   Running mvn clean package...
   Starting application...
   Started AppApplication in X seconds
   ```
4. Deploy 3-5 daqiqa davom etadi

---

### 7. PUBLIC URL OLISH

1. Service → **Settings** → **Networking**
2. **Public Networking** bo'limida → **"Generate Domain"** bosing
3. Sizga URL beriladi, masalan:
   ```
   https://room-monitoring-backend-production-abc123.up.railway.app
   ```

---

### 8. TEKSHIRISH

Brauzerda yoki Postman'da:
```
https://your-app-name.up.railway.app/actuator/health
```

Natija:
```json
{"status":"UP"}
```

---

### 9. FLUTTER ILOVASINI YANGILASH

`mobile/lib/services/api_service.dart` faylida:

```dart
static const String baseUrl = 'https://your-app-name.up.railway.app/api';
```

**Masalan:**
```dart
static const String baseUrl = 'https://room-monitoring-backend-production-abc123.up.railway.app/api';
```

---

### 10. YANGI APK BUILD QILISH

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

## 💰 RAILWAY BEPUL REJASI (2024)

✅ **Yangi akkaunt:**
- **$5 USD credit** (har oy)
- **500 hours** execution time
- **100 GB** bandwidth
- **Unlimited** projects

⚠️ **Cheklovlar:**
- Credit tugasa, service to'xtaydi
- Kredit karta talab qilinmaydi bepul reja uchun
- Har oy yangilanadi ($5)

💡 **Credit tejash:**
- Faqat kerakli paytda ishlatish
- Sleep mode yoqish (ishlatilmasa o'chadi)
- Logs ni minimal qilish

---

## 🔧 DATABASE ULANISH MA'LUMOTLARI

Railway 2 xil database URL beradi:

### 1. **Internal URL** (Service ichida):
```
postgresql://postgres:password@postgres.railway.internal:5432/railway
```
- Faqat Railway ichida ishlaydi
- Tezroq va xavfsizroq
- Environment variable: `DATABASE_URL`

### 2. **Public URL** (Tashqaridan):
```
postgresql://postgres:password@shuttle.proxy.rlwy.net:49209/railway
```
- Tashqi ulanish (pgAdmin, DBeaver)
- Environment variable: `DATABASE_PUBLIC_URL`

**Backend uchun Internal URL ishlatiladi avtomatik.**

---

## 🆘 MUAMMOLAR VA YECHIMLAR

### ❌ Build failed
**Sabab:** Maven yoki Java versiya xatosi
**Yechim:**
1. Service → Settings → Build & Deploy
2. Root Directory: `app` to'g'ri ekanligini tekshiring
3. Logs'ni o'qing

### ❌ Application crashed
**Sabab:** Database ulanmayapti
**Yechim:**
1. Variables bo'limida `DATABASE_URL` borligini tekshiring
2. PostgreSQL service ishlab turganini tekshiring
3. Logs'da qanday xato borligini ko'ring

### ❌ 502 Bad Gateway
**Sabab:** Service ishlamayapti yoki restart qilyapti
**Yechim:**
1. Service Logs'ni tekshiring
2. Service to'xtaganini ko'rsangiz, **Restart** qiling
3. 30-60 soniya kuting

### ❌ Database ulanmayapti (from local)
**Sabab:** Public URL ishlatish kerak
**Yechim:**
1. PostgreSQL service → Connect → Public URL
2. `DATABASE_PUBLIC_URL` dan foydalaning

---

## 📊 SERVICE MONITORING

1. Railway Dashboard'da service'ni oching
2. **Metrics** tab'da ko'ring:
   - CPU usage
   - Memory usage
   - Network traffic
3. **Logs** tab'da real-time logs ko'ring

---

## 🔄 AVTOMATIK DEPLOY (CI/CD)

GitHub bilan ulangan bo'lsa:
1. Har safar `git push` qilsangiz
2. Railway avtomatik detect qiladi
3. Yangi deploy boshlanadi
4. 3-5 daqiqada yangi versiya live bo'ladi

---

## 📝 QISQACHA XULOSA

1. ✅ Railway.app → Login (GitHub/Email)
2. ✅ New Project → Deploy from GitHub
3. ✅ + New → Database → PostgreSQL
4. ✅ Environment Variables (DATABASE_URL, JWT_SECRET)
5. ✅ Settings → Generate Domain
6. ✅ Test: `/actuator/health`
7. ✅ Flutter'da URL yangilash
8. ✅ APK build qilish

---

**MUVAFFAQIYAT! 🎉**

Agar qaysidir bosqichda muammo bo'lsa, logs'ni o'qing yoki yordam so'rang!
