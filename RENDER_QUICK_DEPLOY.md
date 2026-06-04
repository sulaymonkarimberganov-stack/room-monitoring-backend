# ⚡ RENDER.COM - TEZKOR DEPLOY

Railway ishlamayotgan bo'lsa, Render.com ga o'ting - u yerda Dockerfile avtomatik ishlaydi!

---

## 🚀 TEZKOR QADAMLAR:

### 1. RENDER.COM GA KIRISH
```
https://render.com
Login with GitHub
```

### 2. POSTGRESQL YARATISH
```
Dashboard → New + → PostgreSQL
Name: room-monitoring-db
Region: Frankfurt (Europe)
Plan: Free
Create Database
```

**Internal Database URL** ni nusxalang

### 3. WEB SERVICE YARATISH
```
Dashboard → New + → Web Service
Connect Repository: room-monitoring-backend
Deploy
```

**Settings:**
```
Name: room-monitoring-backend
Region: Frankfurt
Branch: main
Runtime: Docker
Instance Type: Free
```

**Environment Variables:**
```
DATABASE_URL = [PostgreSQL'dan nusxalangan URL]
PORT = 8080
JWT_SECRET = room-monitoring-secret-key-for-jwt-token-generation-minimum-256-bits
```

### 4. DEPLOY KUTISH
```
5-10 daqiqa
Logs'da: Started AppApplication in X seconds
```

### 5. URL OLISH
```
Tayyor: https://room-monitoring-backend.onrender.com
Test: https://room-monitoring-backend.onrender.com/actuator/health
```

---

## ✅ RENDER VS RAILWAY:

### **Render:**
- ✅ Dockerfile avtomatik ishlaydi
- ✅ Sozlamalar oddiy
- ✅ 750 soat/oy bepul
- ✅ PostgreSQL bepul
- ⚠️ 15 daqiqa ishlatilmasa sleep mode

### **Railway:**
- ✅ Tezroq
- ✅ $5 credit/oy
- ⚠️ Dockerfile sozlamalari murakkal
- ⚠️ Cache muammolari

---

## 🎯 TAVSIYA:

**Render.com ishlatamiz** - u yerda Dockerfile muammosiz ishlaydi!

---

**5 daqiqada tayyor bo'ladi!** 🚀
