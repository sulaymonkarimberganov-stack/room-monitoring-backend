# 📱 Room Monitoring - Telefon Uchun Tayyor!

## 🎉 APK Muvaffaqiyatli Yaratildi!

### 📍 APK Fayl Joylashuvi
```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

### 📊 APK Ma'lumotlari
- **Fayl nomi:** app-release.apk
- **Hajmi:** 64.45 MB
- **Versiya:** 2.0.0+2
- **Build turi:** Release (optimized)
- **Yaratilgan:** 05.05.2026 11:46
- **Minimum Android:** 7.0 (API 24)
- **Target Android:** 14.0 (API 34)

---

## 📥 Telefonga O'rnatish

### 1️⃣ USB Orqali O'rnatish (Tezkor)

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

**APK faylni telefonga o'tkazish:**

1. **USB orqali:**
   - Telefon ni kompyuterga ulang
   - APK faylni telefon xotirasiga nusxalang
   - Telefonda faylni oching va "O'rnatish" tugmasini bosing

2. **Google Drive / Dropbox orqali:**
   - APK ni cloud ga yuklang
   - Telefonda yuklab oling va o'rnating

3. **Email orqali:**
   - APK ni o'zingizga email qiling
   - Telefonda emailni oching va yuklab oling

4. **Bluetooth orqali:**
   - Boshqa telefondan Bluetooth orqali o'tkazing

---

## ⚙️ Telefon Sozlamalari

### Noma'lum Manbalardan O'rnatish

**Android 8.0 va yuqori:**
1. **Sozlamalar** → **Xavfsizlik va maxfiylik**
2. **Noma'lum manbalardan o'rnatish**
3. Faylni ochayotgan ilovani tanlang:
   - **Chrome** (agar brauzerdan yuklab olgan bo'lsangiz)
   - **Fayllar** / **My Files** (agar fayl menejerdan ochsangiz)
   - **Downloads** (agar yuklab olishlar papkasidan ochsangiz)
4. "Ushbu manbadan ruxsat berish" ni yoqing

**Android 7.0 va past:**
1. **Sozlamalar** → **Xavfsizlik**
2. **Noma'lum manbalar** ni yoqing
3. Ogohlantirishni qabul qiling

---

## 🔐 Login Ma'lumotlari

### 👨‍💼 Admin Hisobi
```
Username: admin
Password: admin123
```
**Ruxsatlar:**
- ✅ Barcha xonalarni ko'rish
- ✅ Barcha vazifalarni boshqarish
- ✅ Foydalanuvchilarni boshqarish
- ✅ Hisobotlarni ko'rish
- ✅ Leaderboard

### 👔 Manager Hisobi
```
Username: manager
Password: manager123
```
**Ruxsatlar:**
- ✅ Xonalarni ko'rish
- ✅ Vazifalarni yaratish va boshqarish
- ✅ Hisobotlarni ko'rish
- ✅ Leaderboard

### 🧹 Cleaner Hisobi
```
Username: cleaner
Password: cleaner123
```
**Ruxsatlar:**
- ✅ O'z vazifalarini ko'rish
- ✅ Vazifalarni bajarish
- ✅ Xonalarni tozalash
- ✅ Buyumlarni skanerlash
- ✅ O'z reytingini ko'rish

---

## ✨ Ilova Xususiyatlari

### 🎨 1. Professional Dark Theme
- Barcha ekranlar uchun yagona dark theme
- Ko'zga qulay ranglar (#1565C0 asosiy rang)
- Yumshoq o'tishlar va animatsiyalar
- Modern glassmorphism effektlar

### ⏳ 2. Loading Holatlar
- Pulsating circle animatsiya
- "Yuklanmoqda..." matni
- Markazda joylashgan
- Professional ko'rinish

### ❌ 3. Error Handling
- Tushunarli xato xabarlari
- "Qayta urinish" tugmasi
- Qizil rang bilan ajratilgan
- Xato ikonkasi

### 📭 4. Empty States
- Har ekran uchun alohida:
  - 🏠 Xonalar yo'q
  - 📋 Vazifalar yo'q
  - 📦 Buyumlar yo'q
- Ikonka + sarlavha + tavsif
- Yordam matnlari

### 📢 5. SnackBar Xabarlari
- **✅ Muvaffaqiyat:** Yashil fon, check ikonka
- **❌ Xato:** Qizil fon, xato ikonka
- **⚠️ Ogohlantirish:** Sariq fon
- **ℹ️ Ma'lumot:** Ko'k fon

### 🌐 6. Internet Tekshiruvi
- Avtomatik internet holatini tekshirish
- Internet yo'q: qizil banner
- Internet qayta ulanganda: yashil banner
- Real-time monitoring
- Avtomatik refresh

### 📸 7. QR Code Scanner
- Xonalarni skanerlash
- Buyumlarni skanerlash
- Tez va aniq
- Kamera ruxsati kerak

### 📊 8. Leaderboard
- Eng yaxshi cleanerlar
- Bajarilgan vazifalar soni
- Reytinglar
- Motivatsiya tizimi

---

## 🚀 Birinchi Ishga Tushirish

### 1. O'rnatish
```bash
adb install mobile/build/app/outputs/flutter-apk/app-release.apk
```

### 2. Ilovani Ochish
- Telefonda "Room Monitoring" ikonkasini toping
- Ilovani oching

### 3. Kirish
- **Cleaner** sifatida test qilish uchun:
  - Username: `cleaner`
  - Password: `cleaner123`
- "Kirish" tugmasini bosing

### 4. Ruxsatlar
Ilova quyidagi ruxsatlarni so'raydi:
- 📷 **Kamera** - QR code skanerlash uchun
- 🌐 **Internet** - Backend bilan aloqa uchun
- 🔔 **Bildirishnomalar** - Push notifications uchun

---

## 🧪 Test Qilish

### Loading Holatini Ko'rish
1. Ilovani oching
2. Login qiling
3. Ma'lumotlar yuklanayotganini kuzating
4. Pulsating animatsiyani ko'ring

### Error Holatini Ko'rish
1. Internet ni o'chiring
2. Biror amalni bajaring (masalan, vazifalarni yangilash)
3. Xato xabarini ko'ring
4. "Qayta urinish" tugmasini bosing

### Empty Holatini Ko'rish
1. Yangi foydalanuvchi yarating
2. Bo'sh ekranlarni ko'ring
3. Yordam matnlarini o'qing

### Internet Tekshiruvini Ko'rish
1. Internet ni o'chiring → qizil banner paydo bo'ladi
2. Internet ni yoqing → yashil banner ko'rinadi
3. Avtomatik refresh ishlaydi

### QR Code Skanerlashni Test Qilish
1. Xonalar ekraniga o'ting
2. QR code tugmasini bosing
3. Kamera ochiladi
4. QR code ni skanerlang

---

## 🔧 Muammolarni Hal Qilish

### ❌ APK O'rnatilmayapti

**Sabab 1: Yetarli joy yo'q**
- Telefonda kamida 100 MB bo'sh joy bo'lishi kerak
- Eski fayllarni o'chiring

**Sabab 2: Noma'lum manbalar yoqilmagan**
- Sozlamalarga o'ting
- "Noma'lum manbalardan o'rnatish" ni yoqing

**Sabab 3: Eski versiya to'sqinlik qilmoqda**
- Eski versiyani o'chiring:
  ```bash
  adb uninstall com.example.room_monitoring
  ```
- Qaytadan o'rnating

### ❌ Ilova Ishlamayapti

**Sabab 1: Internet yo'q**
- WiFi yoki mobil internetni yoqing
- Internet tezligini tekshiring

**Sabab 2: Backend server ishlamayapti**
- Backend serverni ishga tushiring
- Server manzilini tekshiring

**Sabab 3: Ruxsatlar berilmagan**
- Sozlamalar → Ilovalar → Room Monitoring
- Barcha ruxsatlarni yoqing

### ❌ Login Qila Olmayapman

**Sabab 1: Noto'g'ri ma'lumotlar**
- Username va parolni to'g'ri kiriting
- Katta-kichik harflarni tekshiring
- Bo'sh joylar yo'qligini tekshiring

**Sabab 2: Backend bilan aloqa yo'q**
- Internet ulanishini tekshiring
- Backend server ishlab turganligini tekshiring

**Sabab 3: Foydalanuvchi mavjud emas**
- Admin bilan bog'laning
- Yangi foydalanuvchi yarating

### ❌ QR Code Skanerlash Ishlamayapti

**Sabab 1: Kamera ruxsati yo'q**
- Sozlamalar → Ilovalar → Room Monitoring
- Kamera ruxsatini yoqing

**Sabab 2: Kamera band**
- Boshqa ilovalarni yoping
- Telefonni qayta ishga tushiring

**Sabab 3: QR code noto'g'ri**
- QR code aniq va yorug' joyda bo'lishi kerak
- Kamerani to'g'ri yo'naltiring

---

## 📞 Yordam va Qo'llab-quvvatlash

### Muammo Yuzaga Kelsa:

1. **Ilovani qayta ishga tushiring**
   - Ilovani yoping
   - Qaytadan oching

2. **Telefonni qayta ishga tushiring**
   - Telefon ni o'chiring
   - Qaytadan yoqing

3. **APK ni qaytadan o'rnating**
   - Eski versiyani o'chiring
   - Yangi APK ni o'rnating

4. **Cache ni tozalang**
   - Sozlamalar → Ilovalar → Room Monitoring
   - "Cache ni tozalash" tugmasini bosing

5. **Backend loglarini tekshiring**
   - Backend server loglarini ko'ring
   - Xatolarni toping va tuzating

---

## 🎯 Keyingi Qadamlar

### ✅ O'rnatish
1. APK faylni telefonga o'tkazing
2. "Noma'lum manbalardan o'rnatish" ni yoqing
3. APK ni o'rnating

### ✅ Test Qilish
1. Har bir foydalanuvchi turi bilan kiring
2. Barcha funksiyalarni test qiling
3. Xatolarni qayd qiling

### ✅ Feedback Berish
1. Ishlayotgan funksiyalarni qayd qiling
2. Ishlamayotgan funksiyalarni qayd qiling
3. Taklif va fikrlaringizni yuboring

### ✅ Production ga Chiqarish
1. Barcha xatolarni tuzating
2. Signing key yarating
3. Google Play Store ga yuklang

---

## 📱 Telefon Talablari

### Minimum Talablar:
- **Android:** 7.0 (Nougat) yoki yuqori
- **RAM:** 2 GB
- **Bo'sh joy:** 100 MB
- **Internet:** WiFi yoki mobil internet
- **Kamera:** QR code skanerlash uchun

### Tavsiya Etiladi:
- **Android:** 10.0 yoki yuqori
- **RAM:** 4 GB yoki ko'proq
- **Bo'sh joy:** 200 MB yoki ko'proq
- **Internet:** Tez va barqaror ulanish
- **Kamera:** Yaxshi sifatli kamera

---

## 🔒 Xavfsizlik

### Ma'lumotlar Xavfsizligi:
- ✅ Parollar shifrlangan
- ✅ JWT token autentifikatsiya
- ✅ HTTPS orqali aloqa
- ✅ Xavfsiz ma'lumotlar saqlash

### Ruxsatlar:
- 📷 Kamera - faqat QR code skanerlash uchun
- 🌐 Internet - backend bilan aloqa uchun
- 🔔 Bildirishnomalar - push notifications uchun

---

## 📝 Versiya Tarixi

### Versiya 2.0.0+2 (05.05.2026)
- ✅ Professional dark theme
- ✅ Loading, error, empty holatlar
- ✅ SnackBar xabarlari
- ✅ Internet tekshiruvi
- ✅ Core library desugaring
- ✅ flutter_local_notifications 17.2.4

---

**🎉 APK tayyor! Telefonga o'rnating va foydalaning! 📱✨**

**📍 APK joylashuvi:**
```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

**📊 Hajmi:** 64.45 MB
