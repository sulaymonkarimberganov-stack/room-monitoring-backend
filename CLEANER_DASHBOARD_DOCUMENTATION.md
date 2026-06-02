# 🧹 CLEANER Dashboard - To'liq Dokumentatsiya

## 📋 Umumiy Ma'lumot

CLEANER roli uchun maxsus vazifalar dashboard yaratildi. Bu ekran tozalovchi xodimlarga o'z vazifalarini boshqarish va xonalarni tozalash jarayonini kuzatish imkonini beradi.

---

## 🎨 DIZAYN XUSUSIYATLARI

### Dark Glassmorphism Theme
- **Background:** Dark gradient (#0a1929 → #1a2332 → #0d1b2a)
- **Primary Color:** #1565C0 (ko'k)
- **Cards:** Glassmorphism effect (blur + semi-transparent)
- **Borders:** White opacity 0.2
- **Shadows:** Soft shadows with color accents

### Rang Palitra
```dart
Primary Blue:    #1565C0
Dark Blue:       #0D47A1
Success Green:   #4CAF50
Warning Orange:  #FFA726
Grey:            #9E9E9E
Background:      #0a1929 → #1a2332 → #0d1b2a
```

---

## 📱 EKRAN TUZILISHI

### 1. HEADER
**Komponentlar:**
- **Avatar:** Gradient doira (56x56px)
  - Gradient: #1565C0 → #0D47A1
  - Shadow: Ko'k rang shadow
  - Ichida: Foydalanuvchi ismi birinchi harfi

- **Title va Subtitle:**
  - Title: "Mening vazifalarim" (20px, bold, white)
  - Subtitle: Xodim ismi (14px, white opacity 0.7)

- **Notification Icon:**
  - Icon: notifications_outlined
  - Background: White opacity 0.1
  - Border: White opacity 0.2
  - Size: 22px

### 2. STATISTIKA KARTOCHKALARI
**2 ta card:**

**Card 1: Bajarilgan**
- **Icon:** check_circle_rounded
- **Rang:** #4CAF50 (yashil)
- **Ma'lumot:** Bugun bajarilgan vazifalar soni
- **Height:** 120px
- **Animation:** Fade-in + slide-up (600ms)

**Card 2: Qolgan**
- **Icon:** pending_actions_rounded
- **Rang:** #FFA726 (to'q sariq)
- **Ma'lumot:** Qolgan vazifalar soni
- **Height:** 120px
- **Animation:** Fade-in + slide-up (700ms, 100ms delay)

**Card Dizayni:**
- Glassmorphism background
- White gradient (opacity 0.15 → 0.05)
- Border: White opacity 0.2
- Border radius: 20px
- Icon container: Color opacity 0.2, 12px radius
- Value: 32px, bold, white
- Label: 13px, white opacity 0.8

### 3. VAZIFALAR RO'YXATI

**Section Title:**
- "Bugungi vazifalar" (18px, bold, white)

**Vazifa Kartasi:**

**Struktura:**
```
┌─────────────────────────────────────────┐
│ [Icon] Xona 108          [Status Badge] │
│        Standart/Lyuks/Suite             │
│                                         │
│ Vazifa tavsifi (agar mavjud bo'lsa)    │
│                                         │
│ [Boshlash] yoki [Tugallash] tugmasi    │
└─────────────────────────────────────────┘
```

**Xona Ma'lumotlari:**
- Icon: bed_rounded (24px, #1565C0)
- Icon container: #1565C0 opacity 0.2, 12px padding
- Xona raqami: 18px, bold, white
- Xona turi: 13px, white opacity 0.7

**Status Badge:**
3 xil holat:

1. **PENDING (Kutilmoqda)**
   - Rang: Grey (#9E9E9E)
   - Icon: pending_outlined
   - Text: "Kutilmoqda"

2. **IN_PROGRESS (Bajarilmoqda)**
   - Rang: Orange (#FFA726)
   - Icon: hourglass_empty_rounded
   - Text: "Bajarilmoqda"

3. **COMPLETED (Bajarildi)**
   - Rang: Green (#4CAF50)
   - Icon: check_circle_rounded
   - Text: "Bajarildi"

**Badge Dizayni:**
- Padding: 12px horizontal, 6px vertical
- Background: Status color opacity 0.2
- Border: Status color opacity 0.4
- Border radius: 8px
- Icon: 16px
- Text: 12px, bold

**Action Tugmalari:**

1. **Boshlash Tugmasi** (PENDING holat uchun)
   - Gradient: #1565C0 → #1565C0 opacity 0.8
   - Icon: play_arrow_rounded
   - Text: "Boshlash"
   - Shadow: Ko'k rang shadow
   - Border radius: 12px
   - Padding: 12px vertical

2. **Tugallash Tugmasi** (IN_PROGRESS holat uchun)
   - Gradient: #4CAF50 → #4CAF50 opacity 0.8
   - Icon: check_rounded
   - Text: "Tugallash"
   - Shadow: Yashil rang shadow
   - Border radius: 12px
   - Padding: 12px vertical

3. **Bajarilgan Ko'rsatkichi** (COMPLETED holat uchun)
   - Background: #4CAF50 opacity 0.2
   - Border: #4CAF50 opacity 0.3
   - Icon: check_circle_rounded
   - Text: "Bajarilgan"
   - Border radius: 12px
   - Padding: 12px vertical

### 4. BOTTOM NAVIGATION
**2 ta item:**

1. **Vazifalar**
   - Icon: task_alt_rounded
   - Label: "Vazifalar"
   - Active: Gradient (#1565C0 → #0D47A1) + shadow

2. **Profil**
   - Icon: person_rounded
   - Label: "Profil"
   - Active: Gradient (#1565C0 → #0D47A1) + shadow

**Nav Item Dizayni:**
- Padding: 24px horizontal, 10px vertical
- Border radius: 12px
- Active shadow: Ko'k rang shadow (opacity 0.3, blur 8px)
- Icon size: 24px
- Text size: 14px
- Active: White
- Inactive: White opacity 0.5

---

## ⚙️ FUNKSIONALLIK

### 1. Vazifalarni Yuklash
```dart
Future<void> _loadMyTasks() async {
  final api = ApiService();
  final tasks = await api.getMyTasks();
  
  // Calculate statistics
  int completed = tasks.where((t) => t['status'] == 'COMPLETED').length;
  int remaining = tasks.where((t) => t['status'] != 'COMPLETED').length;
  
  setState(() {
    _myTasks = tasks;
    _completedToday = completed;
    _remainingTasks = remaining;
  });
}
```

**Backend Endpoint:**
```
GET /api/tasks/my
Headers: { "Authorization": "Bearer <token>" }
Response: [
  {
    "id": 1,
    "status": "PENDING",
    "description": "Xonani tozalash",
    "room": {
      "id": 108,
      "roomNumber": "108",
      "type": "Standart"
    }
  }
]
```

### 2. Vazifani Boshlash
```dart
Future<void> _startTask(dynamic task) async {
  final api = ApiService();
  final roomId = task['room']['id'];
  
  // Update room status to OCCUPIED (CLEANING)
  await api.updateRoomStatus(roomId, 'OCCUPIED');
  
  // Update task status to IN_PROGRESS
  await api.updateTaskStatus(task['id'], 'IN_PROGRESS');
  
  _loadMyTasks();
}
```

**Backend Endpoints:**
```
PATCH /api/rooms/{id}/status
Body: { "status": "OCCUPIED" }

PATCH /api/tasks/{id}/status
Body: { "status": "IN_PROGRESS" }
```

### 3. Vazifani Tugallash
```dart
Future<void> _completeTask(dynamic task) async {
  // Show photo upload dialog
  final confirmed = await showDialog<bool>(...);
  
  if (confirmed) {
    final api = ApiService();
    final roomId = task['room']['id'];
    
    // Update room status to CLEAN
    await api.updateRoomStatus(roomId, 'CLEAN');
    
    // Update task status to COMPLETED
    await api.updateTaskStatus(task['id'], 'COMPLETED');
    
    _loadMyTasks();
  }
}
```

**Foto Yuklash Dialog:**
- Background: #1a2332 (dark)
- Title: "Vazifani tugatish"
- Content: Xona raqami + foto yuklash opsiyasi
- Icon: camera_alt_outlined
- Buttons: "Bekor qilish" va "Tugallash"

**Backend Endpoints:**
```
PATCH /api/rooms/{id}/status
Body: { "status": "CLEAN" }

PATCH /api/tasks/{id}/status
Body: { "status": "COMPLETED" }
```

### 4. Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: _loadMyTasks,
  color: Color(0xFF1565C0),
  child: SingleChildScrollView(...),
)
```

---

## 🎭 ANIMATSIYALAR

### 1. Header Animation
- **Type:** Fade-in
- **Duration:** 800ms
- **Curve:** easeOut

### 2. Stats Cards Animation
- **Type:** Fade-in + Slide-up
- **Duration:** 600ms (Card 1), 700ms (Card 2)
- **Delay:** 0ms (Card 1), 100ms (Card 2)
- **Curve:** easeOut
- **Offset:** (0, 0.3) → (0, 0)

### 3. Task Cards
- **Type:** Staggered appearance
- **Each card:** Fade-in
- **No explicit animation:** Cards appear as data loads

---

## 📊 HOLAT BOSHQARUVI

### Task Status Flow
```
PENDING → IN_PROGRESS → COMPLETED
   ↓           ↓            ↓
Kutilmoqda  Bajarilmoqda  Bajarildi
   ↓           ↓            ↓
[Boshlash]  [Tugallash]  [✓ Bajarilgan]
```

### Room Status Mapping
```
Task Status      →  Room Status
─────────────────────────────────
PENDING          →  DIRTY
IN_PROGRESS      →  OCCUPIED
COMPLETED        →  CLEAN
```

---

## 🔔 XABARLAR (SnackBar)

### 1. Vazifa Boshlandi
```dart
SnackBar(
  content: Text('Vazifa boshlandi'),
  backgroundColor: Color(0xFF1565C0),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
)
```

### 2. Vazifa Tugallandi
```dart
SnackBar(
  content: Text('Vazifa tugallandi! 🎉'),
  backgroundColor: Color(0xFF4CAF50),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
)
```

### 3. Xatolik
```dart
SnackBar(
  content: Text('Xatolik yuz berdi'),
  backgroundColor: Colors.red.shade400,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
)
```

---

## 📱 RESPONSIVE DIZAYN

### Padding va Spacing
- Screen padding: 20px
- Card margin: 16px bottom
- Card padding: 20px
- Stats cards gap: 12px
- Section spacing: 24px

### Font Sizes
- Header title: 20px
- Header subtitle: 14px
- Stats value: 32px
- Stats label: 13px
- Section title: 18px
- Room number: 18px
- Room type: 13px
- Status text: 12px
- Button text: 14px
- Nav label: 14px

---

## 🚀 BACKEND REQUIREMENTS

### Required Endpoints

1. **Get My Tasks**
```
GET /api/tasks/my
Headers: Authorization: Bearer <token>
Response: [
  {
    "id": 1,
    "status": "PENDING" | "IN_PROGRESS" | "COMPLETED",
    "description": "Xonani tozalash",
    "assignedTo": { "id": 1, "username": "cleaner" },
    "room": {
      "id": 108,
      "roomNumber": "108",
      "type": "Standart" | "Lyuks" | "Suite",
      "status": "DIRTY" | "OCCUPIED" | "CLEAN"
    },
    "createdAt": "2026-05-05T10:00:00Z",
    "updatedAt": "2026-05-05T10:00:00Z"
  }
]
```

2. **Update Room Status**
```
PATCH /api/rooms/{id}/status
Headers: Authorization: Bearer <token>
Body: { "status": "OCCUPIED" | "CLEAN" }
Response: {
  "id": 108,
  "roomNumber": "108",
  "status": "CLEAN",
  "updatedAt": "2026-05-05T11:00:00Z"
}
```

3. **Update Task Status**
```
PATCH /api/tasks/{id}/status
Headers: Authorization: Bearer <token>
Body: { "status": "IN_PROGRESS" | "COMPLETED" }
Response: {
  "id": 1,
  "status": "COMPLETED",
  "updatedAt": "2026-05-05T11:00:00Z"
}
```

### Optional Endpoints (Future)

4. **Upload Photo**
```
POST /api/tasks/{id}/photo
Headers: Authorization: Bearer <token>
Content-Type: multipart/form-data
Body: { "photo": <file> }
Response: {
  "id": 1,
  "photoUrl": "https://example.com/photos/task-1.jpg"
}
```

---

## 🎯 FOYDALANUVCHI OQIMI

### 1. Login
```
User → Login Screen → Enter credentials → Backend validates
→ JWT token returned → Decode role → Route to CleanerDashboardScreen
```

### 2. Vazifalarni Ko'rish
```
CleanerDashboardScreen → Load tasks → GET /api/tasks/my
→ Display task cards → Show statistics
```

### 3. Vazifani Boshlash
```
User → Tap "Boshlash" → Confirm action
→ PATCH /api/rooms/{id}/status (OCCUPIED)
→ PATCH /api/tasks/{id}/status (IN_PROGRESS)
→ Reload tasks → Show success message
```

### 4. Vazifani Tugallash
```
User → Tap "Tugallash" → Show photo dialog
→ User confirms → PATCH /api/rooms/{id}/status (CLEAN)
→ PATCH /api/tasks/{id}/status (COMPLETED)
→ Reload tasks → Show success message with emoji
```

### 5. Pull-to-Refresh
```
User → Pull down → Trigger refresh → GET /api/tasks/my
→ Update UI → Hide loading indicator
```

---

## 📊 STATISTIKA HISOBLASH

```dart
// Bugun bajarilgan vazifalar
int completed = tasks.where((t) => t['status'] == 'COMPLETED').length;

// Qolgan vazifalar (PENDING + IN_PROGRESS)
int remaining = tasks.where((t) => t['status'] != 'COMPLETED').length;
```

---

## 🎨 EMPTY STATE

Agar vazifalar bo'lmasa:
```
┌─────────────────────────────────┐
│                                 │
│         [Task Icon]             │
│                                 │
│      Vazifalar yo'q             │
│                                 │
│  Sizga hali vazifa biriktirilmagan │
│                                 │
└─────────────────────────────────┘
```

**Dizayn:**
- Icon: task_alt_rounded (80px, white opacity 0.3)
- Title: 18px, bold, white opacity 0.7
- Subtitle: 14px, white opacity 0.5
- Padding: 40px

---

## ✨ ASOSIY XUSUSIYATLAR

✅ Dark glassmorphism dizayn  
✅ Real-time task updates  
✅ Pull-to-refresh  
✅ Status-based actions  
✅ Photo upload dialog  
✅ Smooth animations  
✅ Statistics tracking  
✅ Empty state handling  
✅ Error handling  
✅ Success notifications  
✅ Responsive layout  
✅ Professional UI/UX  

---

## 🔧 TEXNIK TAFSILOTLAR

### Dependencies
```yaml
flutter: sdk
provider: ^6.1.2
google_fonts: ^6.1.0
http: ^1.2.1
shared_preferences: ^2.2.3
```

### State Management
- **Provider:** AuthProvider
- **Local State:** StatefulWidget with setState
- **API Calls:** ApiService

### Performance
- **Lazy loading:** Tasks loaded on demand
- **Caching:** Token cached in SharedPreferences
- **Animations:** Hardware-accelerated
- **Images:** Network images with caching

---

**Yaratilgan Sana:** 2026-05-05  
**Versiya:** 3.1.0  
**Status:** ✅ Production Ready
