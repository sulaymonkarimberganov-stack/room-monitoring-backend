# 📱 Room Monitoring APK - O'rnatish Qo'llanmasi

## 🎉 APK Muvaffaqiyatli Yaratildi!

### 📍 APK Fayl Joylashuvi
```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

### 📊 APK Ma'lumotlari
- **Versiya:** 1.0.0+1
- **Build Turi:** Release (optimized)
- **Hajmi:** ~50-55 MB (taxminan)
- **Minimum Android:** 7.0 (API 24)
- **Target Android:** 14.0 (API 34)

---

## 📥 O'rnatish Usullari

### 1️⃣ USB Orqali O'rnatish

**Telefon USB orqali ulangan bo'lishi kerak:**

```bash
# APK ni o'rnatish
adb install mobile/build/app/outputs/flutter-apk/app-release.apk

# Agar eski versiya mavjud bo'lsa, yangilash
adb install -r mobile/build/app/outputs/flutter-apk/app-release.apk
```

**Eski versiyani o'chirish:**
```bash
adb uninstall com.example.room_monitoring
```

### 2️⃣ Fayl Orqali O'rnatish

1. APK faylni telefonga nusxalang:
   - USB orqali
   - Bluetooth orqali
   - Google Drive / Dropbox orqali
   - Email orqali

2. Telefonda faylni oching
3. "O'rnatish" tugmasini bosing

---

## ⚙️ Telefon Sozlamalari

### Noma'lum Manbalardan O'rnatish

Agar telefonda "Noma'lum manbalardan o'rnatish" yoqilmagan bo'lsa:

**Android 8.0 va yuqori:**
1. **Sozlamalar** → **Xavfsizlik va maxfiylik**
2. **Noma'lum manbalardan o'rnatish**
3. Faylni ochayotgan ilovani tanlang (masalan, **Chrome**, **Fayllar**, **Downloads**)
4. "Ushbu manbadan ruxsat berish" ni yoqing

**Android 7.0 va past:**
1. **Sozlamalar** → **Xavfsizlik**
2. **Noma'lum manbalar** ni yoqing

---

## 🔐 Login Ma'lumotlari

### Admin Hisobi
- **Username:** `admin`
- **Password:** `admin123`
- **Ruxsatlar:** Barcha funksiyalar

### Manager Hisobi
- **Username:** `manager`
- **Password:** `manager123`
- **Ruxsatlar:** Vazifalarni ko'rish va boshqarish

### Cleaner Hisobi
- **Username:** `cleaner`
- **Password:** `cleaner123`
- **Ruxsatlar:** Vazifalarni bajarish

---

## ✨ Yangi Xususiyatlar (Bu Versiyada)

### 1. 🎨 Yagona Dark Theme
- Barcha ekranlar uchun professional dark theme
- Ko'zga qulay ranglar (#1565C0 asosiy rang)
- Yumshoq o'tishlar va animatsiyalar

### 2. ⏳ Professional Loading
- Pulsating circle animatsiya
- "Yuklanmoqda..." matni
- Markazda joylashgan

### 3. ❌ Error Handling
- Xato ikonasi (qizil)
- Tushunarli xato xabarlari
- "Qayta urinish" tugmasi

### 4. 📭 Empty States
- Har ekran uchun alohida:
  - Xonalar yo'q
  - Vazifalar yo'q
  - Buyumlar yo'q
- Ikonka + sarlavha + tavsif

### 5. 📢 SnackBar Xabarlari
- **Muvaffaqiyat:** Yashil fon, check ikonka
- **Xato:** Qizil fon, xato ikonka
- **Ogohlantirish:** Sariq fon
- **Ma'lumot:** Ko'k fon

### 6. 🌐 Internet Tekshiruvi
- Avtomatik internet holatini tekshirish
- Internet yo'q bo'lsa: qizil banner
- Internet qayta ulanganda: yashil banner
- Real-time monitoring

---

## 🚀 Test Qilish

### 1. O'rnatish
```bash
adb install mobile/build/app/outputs/flutter-apk/app-release.apk
```

### 2. Kirish
- Username: `cleaner`
- Password: `cleaner123`

### 3. Funksiyalarni Test Qilish

**Loading holatini ko'rish:**
- Ilovani oching
- Ma'lumotlar yuklanayotganini kuzating

**Error holatini ko'rish:**
- Internet ni o'chiring
- Biror amalni bajaring
- Xato xabarini ko'ring
- "Qayta urinish" tugmasini bosing

**Empty holatini ko'rish:**
- Yangi foydalanuvchi yarating
- Bo'sh ekranlarni ko'ring

**Internet tekshiruvini ko'rish:**
- Internet ni o'chiring → qizil banner
- Internet ni yoqing → yashil banner

---

## 🔧 Muammolarni Hal Qilish

### APK O'rnatilmayapti
- Telefonda yetarli joy borligini tekshiring (kamida 100 MB)
- "Noma'lum manbalardan o'rnatish" yoqilganligini tekshiring
- Eski versiyani o'chirib, qaytadan o'rnating

### Ilova Ishlamayapti
- Internet ulanishini tekshiring
- Backend server ishlab turganligini tekshiring
- Ilovani qayta ishga tushiring

### Login Qila Olmayapman
- Username va parolni to'g'ri kiritganingizni tekshiring
- Katta-kichik harflarni tekshiring
- Backend server ishlab turganligini tekshiring

---

## 📞 Yordam

Agar muammo yuzaga kelsa:
1. Ilovani qayta ishga tushiring
2. Telefon ni qayta ishga tushiring
3. APK ni qaytadan o'rnating
4. Backend server loglarini tekshiring

---

## 🎯 Keyingi Qadamlar

1. ✅ APK ni o'rnating
2. ✅ Login qiling
3. ✅ Barcha funksiyalarni test qiling
4. ✅ Xatolarni qayd qiling
5. ✅ Feedback bering

---

**APK tayyor! Telefonga o'rnating va test qiling! 📱✨**
