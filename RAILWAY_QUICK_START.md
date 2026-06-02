# ⚡ RAILWAY - TEZKOR BOSHLASH

## 1️⃣ RAILWAY.APP GA KIRING
🔗 https://railway.app
- Login → GitHub bilan kiring

## 2️⃣ YANGI PROJECT YARATING
1. Dashboard → **"New Project"**
2. **"Deploy from GitHub repo"** tanlang
3. Repository'ni tanlang
4. **"Deploy Now"** bosing

## 3️⃣ DATABASE QO'SHING
1. Project ichida → **"+ New"**
2. **"Database"** → **"PostgreSQL"**
3. Tayyor! `DATABASE_URL` avtomatik qo'shiladi

## 4️⃣ PUBLIC URL OLING
1. Service (backend) → **"Settings"**
2. **"Networking"** → **"Generate Domain"**
3. URL nusxalang:
   ```
   https://your-app.up.railway.app
   ```

## 5️⃣ TEKSHIRISH
Brauzerda:
```
https://your-app.up.railway.app/actuator/health
```

Natija: `{"status":"UP"}` ✅

## 6️⃣ FLUTTER'DA URL YANGILANG
`mobile/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-app.up.railway.app/api';
```

## 7️⃣ APK BUILD QILING
```bash
cd mobile
flutter clean
flutter build apk --release
```

---

## 📞 MUAMMO BO'LSA?
Batafsil qo'llanma: `RAILWAY_DEPLOY_GUIDE.md`

## 🎯 ENVIRONMENT VARIABLES (Agar kerak bo'lsa)
Service → **Variables**:
- `DATABASE_URL` - avtomatik qo'shiladi ✅
- `PORT` - avtomatik 8080 ✅
- `JWT_SECRET` - qo'lda qo'shing (agar xato bo'lsa)

---

**JAMi VAQT: 5-10 daqiqa** ⏱️
