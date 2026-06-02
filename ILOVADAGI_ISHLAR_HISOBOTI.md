# 📱 Room Monitoring Mobile App - To'liq Hisobot

## 📊 Umumiy Ma'lumot

**Ilova Nomi:** Room Monitoring  
**Versiya:** 2.0.0+2  
**APK Hajmi:** 49.1 MB  
**Platforma:** Android (Min SDK 21 - Lollipop 5.0)  
**Backend URL:** https://room-monitoring-backend-production.up.railway.app/api  
**Kirish Ma'lumotlari:** username: `admin`, password: `admin123`

---

## 🎨 DIZAYN VA INTERFEYS

### 1. **LOGIN EKRANI** (Professional Hotel Design)

#### Fon Rasm:
- **URL:** `https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=1080&q=90`
- **Tip:** Professional mehmonxona xonasi
- **BoxFit:** cover (to'liq qoplash)

#### Gradient Overlay:
- **Yo'nalish:** 170 daraja
- **Ranglar:**
  - rgba(5,10,30,0.4) → rgba(5,15,50,0.65) → rgba(3,8,25,0.88)
- **Maqsad:** Matnni yaxshi ko'rinishini ta'minlash

#### Hotel Badge (Yuqori qism):
- **Icon:** Oltin yulduz (Icons.star)
- **Matn:** "HOTEL"
- **Rang:** #FFD700 (oltin)
- **Font Size:** 9px
- **Letter Spacing:** 2px
- **Style:** Bold, uppercase

#### Sarlavha:
- **Matn:** "Room Monitor"
- **Rang:** Oq (white)
- **Font Size:** 20px
- **Font Weight:** Bold
- **Letter Spacing:** 0.5px

#### Glassmorphism Card:
- **Background:** rgba(255,255,255,0.08) - yarim shaffof oq
- **Border:** rgba(255,215,0,0.12) - oltin border
- **Border Radius:** 20px
- **Blur Effect:** sigmaX: 10, sigmaY: 10
- **Padding:** 28px

#### Input Fieldlar:
- **Background:** rgba(255,255,255,0.07)
- **Border:** rgba(255,215,0,0.1) - oltin
- **Border Radius:** 14px
- **Icon Rang:** #FFD700 opacity 0.5 (oltin)
- **Matn Rang:** Oq
- **Font Size:** 15px

#### Kirish Tugmasi:
- **Gradient:** #B8960C → #FFD700 → #B8960C (oltin gradient)
- **Matn Rang:** #1a1000 (qora)
- **Font Weight:** Bold
- **Height:** 56px
- **Border Radius:** 16px
- **Shadow:** Oltin rang shadow (opacity 0.3, blur 15px)

#### Animatsiya:
- **Fade-in:** 1500ms
- **Curve:** easeInOut
- **Effect:** Butun ekran yumshoq paydo bo'ladi

#### Offline Fallback:
- **Gradient Background:** #0a0e1a → #050a19 → #030812
- **Maqsad:** Internet bo'lmasa ham chiroyli ko'rinish

---

### 2. **DASHBOARD EKRANI** (Premium SaaS Style)

#### Fon Rasm:
- **URL:** `https://i.pinimg.com/736x/b7/e4/f3/b7e4f3b3da5444c127b76032894c924a.jpg`
- **Tip:** Zamonaviy mehmonxona xonasi
- **Overlay:** 30% qora (darken)

#### Gradient Overlay:
- **Yo'nalish:** Yuqoridan pastga
- **Ranglar:**
  - #0D47A1 (opacity 0.85)
  - #1565C0 (opacity 0.75)
  - #1976D2 (opacity 0.65)
- **Blur Effect:** sigmaX: 2, sigmaY: 2

#### Header:
- **Sarlavha:** "Room Monitoring"
- **Font Size:** 28px
- **Font Weight:** Bold
- **Rang:** Oq
- **Avatar:** Gradient doira (50x50px)
  - Gradient: #1565C0 → #5E35B1
  - Shadow: Ko'k rang shadow

#### Stats Cards (Glassmorphism):
**Card 1: Jami Xonalar**
- **Icon:** Icons.bed_rounded
- **Rang:** #1565C0 (ko'k)
- **Background:** Gradient (white opacity 0.25 → 0.15)
- **Border:** Oq (opacity 0.3)
- **Shadow:** Ko'k rang shadow
- **Height:** 110px
- **Border Radius:** 20px

**Card 2: Toza Xonalar**
- **Icon:** Icons.check_circle_rounded
- **Rang:** #4CAF50 (yashil)
- **Style:** Yuqoridagi bilan bir xil

**Card 3: Iflos Xonalar** (Dashboard ichida ko'rsatilmaydi, lekin hisoblanadi)
- **Rang:** #EF5350 (qizil)

**Card 4: Jarayonda** (Dashboard ichida ko'rsatilmaydi, lekin hisoblanadi)
- **Rang:** #FFA726 (to'q sariq)

#### Animatsiyalar:
- **Fade-in:** 800ms
- **Slide-up:** 0.3 offset → 0
- **Staggered:** Har bir card 100ms kechikish bilan
- **Curve:** easeOut

#### AI Tavsiya Panel:
- **Background:** Gradient (purple opacity 0.3 → blue opacity 0.2)
- **Border:** Oq (opacity 0.3)
- **Border Radius:** 16px
- **Icon:** Icons.auto_awesome_rounded (AI icon)
- **Matn:** "AI Tavsiya: X ta xona qayta tozalash kerak"
- **Font Size:** 12-13px

#### Filter Tugmalari:
- **Variantlar:** Barchasi, Toza, Tozalanmagan, Jarayonda
- **Active Style:**
  - Gradient: #1565C0 → #5E35B1
  - Border: Oq (opacity 0.5)
  - Shadow: Ko'k rang shadow
  - Check icon ko'rsatiladi
- **Inactive Style:**
  - Background: Oq (opacity 0.2)
  - Border: Oq (opacity 0.3)
- **Border Radius:** 25px (pill shape)
- **Padding:** 20px horizontal, 12px vertical
- **Animation:** 300ms smooth transition

#### Xona Kartochkalari:
- **Background:** Oq
- **Border Radius:** 16px
- **Shadow:** Qora (opacity 0.08, blur 10px)
- **Padding:** 16px
- **Margin Bottom:** 12px

**Status Indicator:**
- **Size:** 50x50px
- **Border Radius:** 12px
- **Icon Size:** 28px
- **Ranglar:**
  - Toza: #4CAF50 (yashil) + Icons.check_circle_rounded
  - Tozalanmagan: #EF5350 (qizil) + Icons.cancel_rounded
  - Jarayonda: #FFA726 (to'q sariq) + Icons.access_time_rounded

**Xona Ma'lumotlari:**
- **Sarlavha:** "Xona 108" (16px, bold)
- **Subtitle:** "qavat • status" (13px, grey)
- **Edit Icon:** 
  - Background: #1565C0 (opacity 0.1)
  - Icon: Icons.edit_rounded (20px)
  - Border Radius: 10px

#### Pull-to-Refresh:
- **Rang:** Oq
- **Funksiya:** Statistikani yangilash

---

### 3. **PROFILE EKRANI** (Modern iOS Style)

#### Fon Rasm:
- **URL:** `https://i.pinimg.com/736x/b7/e4/f3/b7e4f3b3da5444c127b76032894c924a.jpg`
- **Overlay:** 50% qora (darken)

#### Header:
- **Sarlavha:** "Room Monitoring"
- **Font Size:** 22px (compact)
- **Subtitle:** "Tizimni boshqarish paneli"
- **Font Size:** 12px (thin)
- **Logout Icon:** Top-right icon button (Icons.logout)

#### Profile Card:
- **Avatar Size:** 70px (compact)
- **Badge:**
  - Matn: "Administrator"
  - Padding: 10x4 (compact)
  - Font Size: 11px
  - Rang: Yashil (#4CAF50)
  - Border Radius: 12px

#### Ma'lumot Qatorlari:
- **Label Font Size:** 11px (kichik)
- **Value Font Size:** 14px
- **Icon Size:** 20px
- **Spacing:** Compact va balanced

#### Chiqish Tugmasi:
- **Height:** 48px (kichik)
- **Rang:** Red 400 (#EF5350)
- **Shape:** Pill-shaped (rounded)
- **Border Radius:** 24px
- **Style:** Subtle lekin ko'rinadigan

---

### 4. **BOSHQA EKRANLAR**

#### Tasks Screen (Vazifalar):
- **AppBar:** Ko'k (#1565C0)
- **Sarlavha:** "Vazifalar"
- **Style:** Minimal va clean

#### Inventory Screen (Buyumlar):
- **AppBar:** Ko'k (#1565C0)
- **Sarlavha:** "Buyumlar"
- **Style:** Minimal va clean

---

## 🎨 RANG PALITRA

### Asosiy Ranglar:
- **Primary Blue:** #1565C0
- **Dark Blue:** #0D47A1
- **Light Blue:** #1976D2
- **Purple:** #5E35B1

### Oltin Ranglar (Login):
- **Gold:** #FFD700
- **Dark Gold:** #B8960C
- **Button Text:** #1a1000 (qora)

### Status Ranglar:
- **Clean (Toza):** #4CAF50 (yashil)
- **Dirty (Iflos):** #EF5350 (qizil)
- **In Progress (Jarayonda):** #FFA726 (to'q sariq)

### Yordamchi Ranglar:
- **White:** #FFFFFF
- **Black:** #000000
- **Grey 600:** #757575
- **Grey 800:** #424242
- **Grey 900:** #212121

---

## 📝 TIPOGRAFIYA

### Font Family:
- **Asosiy:** Poppins (Google Fonts)
- **Style:** Modern, clean, professional

### Font Sizes:
- **9px:** Hotel badge, kichik labellar
- **11px:** Profile badge, nav labels
- **12px:** Subtitles, kichik matnlar
- **13px:** Body text, filter labels
- **14px:** Input labels, medium text
- **15px:** Input values
- **16px:** Card titles, button text
- **20px:** Login title
- **22px:** Profile title
- **28px:** Dashboard title, stat values

### Font Weights:
- **Normal (400):** Oddiy matn
- **Medium (500):** Filter buttons
- **SemiBold (600):** Subtitles, labels
- **Bold (700):** Titles, sarlavhalar

---

## ⚡ ANIMATSIYALAR

### Login Screen:
- **Fade-in:** 1500ms, easeInOut
- **Effect:** Butun ekran yumshoq paydo bo'ladi

### Dashboard Stats Cards:
- **Fade-in:** 800ms, easeOut
- **Slide-up:** 600-800ms, offset 0.3 → 0
- **Staggered:** Har bir card 100ms kechikish
- **Curve:** easeOut

### Filter Buttons:
- **Transition:** 300ms, easeInOut
- **Effect:** Smooth color va shadow o'zgarishi

### Room Cards:
- **Hover/Press:** Lift effect
- **Edit Icon:** Micro-interaction

---

## 🔧 TEXNIK TAFSILOTLAR

### Dependencies:
```yaml
flutter: sdk
http: ^1.2.1
shared_preferences: ^2.2.3
provider: ^6.1.2
cupertino_icons: ^1.0.6
glassmorphism: ^3.0.0
google_fonts: ^6.1.0
flutter_animate: ^4.5.0
```

### Backend Integration:
- **Base URL:** https://room-monitoring-backend-production.up.railway.app/api
- **Auth:** JWT token
- **Endpoints:**
  - POST /auth/login
  - GET /rooms
  - PUT /rooms/{id}/status
  - GET /tasks
  - GET /inventory

### State Management:
- **Provider:** AuthProvider
- **Shared Preferences:** Token saqlash
- **Real-time Updates:** Pull-to-refresh

---

## 📱 EKRAN RAZMER VA LAYOUT

### Login Screen:
- **Layout:** Center aligned
- **Card Width:** Full width - 48px padding (24px har tarafdan)
- **Card Padding:** 28px
- **Vertical Spacing:** 8-40px orasida

### Dashboard Screen:
- **Header Height:** ~90px
- **Stats Cards:** 2 ta qator (2x2 grid mumkin)
- **Card Height:** 110px
- **Horizontal Padding:** 20px
- **Card Spacing:** 12px

### Profile Screen:
- **Avatar Size:** 70x70px
- **Card Padding:** 16-20px
- **Button Height:** 48px

---

## 🚀 BUILD VA DEPLOYMENT

### Build Command:
```bash
flutter build apk --release --no-tree-shake-icons
```

### APK Location:
```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

### Build Time:
- **Average:** 218 seconds (~3.6 daqiqa)

### APK Size:
- **Release:** 49.1 MB

### Installation Notes:
1. Eski ilovani o'chirish
2. Telefonni restart qilish (cache tozalash)
3. Yangi APK ni o'rnatish

---

## ✨ ASOSIY XUSUSIYATLAR

### 1. **Glassmorphism Design**
- Zamonaviy, premium ko'rinish
- Yarim shaffof blur effektlar
- Soft shadows va borders

### 2. **Professional Hotel Theme**
- Mehmonxona xonasi background
- Oltin rang aksentlar
- Premium typography

### 3. **Smooth Animations**
- Fade-in effektlar
- Slide-up transitions
- Staggered card animations
- Micro-interactions

### 4. **Real-time Data**
- Backend bilan integratsiya
- Pull-to-refresh
- Status yangilash

### 5. **Modern UI/UX**
- iOS-style compact design
- Intuitive navigation
- Clean hierarchy
- Responsive layout

### 6. **AI Suggestions**
- Smart recommendations
- Priority tasks
- Cleaning suggestions

---

## 📊 STATISTIKA FUNKSIYALARI

### Dashboard Stats:
- **Jami Xonalar:** Barcha xonalar soni
- **Toza Xonalar:** CLEAN status
- **Iflos Xonalar:** DIRTY status
- **Jarayonda:** OCCUPIED status

### Filter Options:
- **Barchasi:** Barcha xonalarni ko'rsatish
- **Toza:** Faqat toza xonalar
- **Tozalanmagan:** Faqat iflos xonalar
- **Jarayonda:** Faqat jarayondagi xonalar

---

## 🎯 DIPLOMA LOYIHASI UCHUN

### Professional Features:
✅ Modern glassmorphism design  
✅ Premium hotel theme  
✅ Smooth animations  
✅ Real-time data integration  
✅ AI suggestions panel  
✅ Clean architecture  
✅ Reusable widgets  
✅ Professional typography  
✅ Responsive layout  
✅ Production-ready code  

### Presentation Points:
1. **Zamonaviy Dizayn:** Glassmorphism va premium hotel theme
2. **Professional UI/UX:** iOS-style compact va clean interface
3. **Backend Integration:** Railway platformasida deploy qilingan API
4. **Real-time Updates:** Pull-to-refresh va instant status updates
5. **AI Features:** Smart recommendations va priority suggestions
6. **Production Quality:** 49.1 MB optimized APK

---

## 📝 FAYLLAR STRUKTURASI

```
mobile/
├── lib/
│   ├── screens/
│   │   ├── login_screen.dart (Professional hotel design)
│   │   ├── dashboard_screen.dart (Premium SaaS style)
│   │   ├── profile_screen.dart (Modern iOS style)
│   │   ├── rooms_screen.dart
│   │   ├── tasks_screen.dart
│   │   └── inventory_screen.dart
│   ├── providers/
│   │   └── auth_provider.dart
│   ├── services/
│   │   └── api_service.dart
│   └── main.dart
├── pubspec.yaml
└── build/
    └── app/
        └── outputs/
            └── flutter-apk/
                └── app-release.apk (49.1 MB)
```

---

## 🔐 KIRISH MA'LUMOTLARI

**Username:** admin  
**Password:** admin123  
**Backend:** https://room-monitoring-backend-production.up.railway.app/api

---

## 📸 EKRAN SCREENSHOTS

### Login Screen:
- Professional mehmonxona xonasi fon
- Oltin rang hotel badge
- Glassmorphism card
- Oltin gradient kirish tugmasi

### Dashboard Screen:
- Zamonaviy xona fon
- Ko'k gradient overlay
- Glassmorphism stats cards
- AI tavsiya panel
- Filter tugmalari
- Xona kartochkalari

### Profile Screen:
- Compact iOS-style design
- Kichik avatar va badge
- Clean ma'lumot qatorlari
- Pill-shaped logout button

---

**Yaratilgan Sana:** 2026-05-05  
**Versiya:** 2.0.0+2  
**Status:** Production Ready ✅
