# 📊 Statistika Ekrani - To'liq Dokumentatsiya

## 📋 Umumiy Ma'lumot

Admin va Manager rollari uchun professional statistika ekrani yaratildi. Bu ekran haftalik tozalash grafikini, samaradorlik ko'rsatkichlarini va o'rtacha tozalash vaqtini ko'rsatadi.

---

## 🎨 DIZAYN XUSUSIYATLARI

### Dark Theme
```dart
Background: #0a0e1a (dark blue-black)
Primary:    #1565C0 (ko'k)
Success:    #81C784 (yashil)
Info:       #90CAF9 (och ko'k)
```

### Glassmorphism Cards
- **Background:** White gradient (opacity 0.15 → 0.05)
- **Border:** White opacity 0.2, 1.5px
- **Border Radius:** 20px
- **Blur:** sigmaX: 10, sigmaY: 10
- **Font:** Poppins (Google Fonts)

---

## 📱 EKRAN KOMPONENTLARI

### 1. AppBar
```
┌─────────────────────────────────────────┐
│ [←] Statistika                          │
└─────────────────────────────────────────┘
```
- Background: #0a0e1a
- Title: "Statistika" (Poppins, 16px, bold, white)
- Back button: White
- Elevation: 0

### 2. Period Filter (Toggle Buttons)
```
┌─────────────────────────────────────────┐
│ [7 kun] [30 kun] [3 oy]                │
└─────────────────────────────────────────┘
```
- Container: White opacity 0.05, border white opacity 0.1
- Active button: Gradient (#1565C0 → #0D47A1)
- Inactive button: Transparent
- Border radius: 12px (container), 10px (buttons)
- Padding: 4px (container), 12px vertical (buttons)
- Font: 14px, bold (active), medium (inactive)
- Animation: 200ms smooth transition

### 3. Metric Cards (2x1 Grid)
```
┌──────────────────┐  ┌──────────────────┐
│ [↗️] 87.5%       │  │ [⏱️] 23.4 daq    │
│ Samaradorlik     │  │ O'rtacha vaqt    │
└──────────────────┘  └──────────────────┘
```

**Card 1: Samaradorlik**
- Icon: trending_up_rounded (24px)
- Icon container: #81C784 opacity 0.2, 12px radius
- Icon color: #81C784 (yashil)
- Value: 28px, bold, white
- Label: 13px, white opacity 0.7
- Animation: Slide-up + fade-in (600ms)

**Card 2: O'rtacha Vaqt**
- Icon: timer_outlined (24px)
- Icon container: #90CAF9 opacity 0.2, 12px radius
- Icon color: #90CAF9 (och ko'k)
- Value: 28px, bold, white
- Label: 13px, white opacity 0.7
- Animation: Slide-up + fade-in (700ms, 100ms delay)

**Card Dizayni:**
- Height: Auto (content-based)
- Padding: 20px
- Glassmorphism background
- Border: White opacity 0.2
- Border radius: 20px

### 4. Haftalik Grafik (BarChart)
```
┌─────────────────────────────────────────┐
│ [📊] Haftalik tozalash                  │
│                                         │
│     20 ┤                                │
│     15 ┤    ▓▓▓▓  ▓▓▓▓                 │
│     10 ┤ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            │
│      5 ┤ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓ │
│      0 └─────────────────────────────── │
│         Du Se Ch Pa Ju Sh Ya           │
└─────────────────────────────────────────┘
```

**Chart Xususiyatlari:**
- **Height:** 250px
- **Type:** BarChart (fl_chart)
- **Max Y:** 20
- **Min Y:** 0
- **Bar Width:** 24px
- **Border Radius:** 6px (top only)

**X O'qi (Kunlar):**
- Labels: Du, Se, Ch, Pa, Ju, Sh, Ya
- Font: Poppins, 12px, medium
- Color: White opacity 0.7
- Padding: 8px top

**Y O'qi (Soni):**
- Interval: 5
- Font: Poppins, 11px
- Color: White opacity 0.5
- Reserved size: 32px

**Grid Lines:**
- Horizontal: White opacity 0.1, 1px
- Vertical: Yo'q
- Interval: 5

**Bar Colors:**
- **Faol kun (Ya - bugun):** Gradient (#1565C0 → #0D47A1)
- **Qolgan kunlar:** Gradient (#1565C0 opacity 0.4 → #0D47A1 opacity 0.4)

**Tooltip:**
- Background: #1565C0
- Border radius: 8px
- Padding: 12px horizontal, 8px vertical
- Text: "X ta xona" (Poppins, 12px, bold, white)

### 5. Jami Tozalangan Card
```
┌─────────────────────────────────────────┐
│ [✓] Jami tozalangan                [→] │
│     82 ta xona                          │
└─────────────────────────────────────────┘
```
- Icon: check_circle_rounded (32px, #1565C0)
- Icon container: #1565C0 opacity 0.3, 16px radius, 16px padding
- Title: 14px, white opacity 0.8
- Value: 28px, bold, white
- Arrow: arrow_forward_ios_rounded (20px, white opacity 0.5)
- Background: Gradient (#1565C0 opacity 0.3 → #0D47A1 opacity 0.2)
- Border: White opacity 0.2
- Border radius: 20px
- Padding: 20px

---

## ⚙️ FUNKSIONALLIK

### 1. Statistikani Yuklash
```dart
Future<void> _loadStatistics() async {
  final api = ApiService();
  
  // Get weekly data
  final weeklyData = await api.getWeeklyStatistics();
  // Response: { days: [{date, count}] }
  
  // Get summary
  final summary = await api.getStatisticsSummary();
  // Response: { efficiency, avgTime, total }
  
  setState(() {
    _weeklyData = weeklyData['days'];
    _efficiency = summary['efficiency'];
    _avgTime = summary['avgTime'];
    _totalCleaned = summary['total'];
  });
}
```

### 2. Period Filter
```dart
void _onPeriodChanged(String period) {
  setState(() => _selectedPeriod = period);
  _loadStatistics(); // Reload with new period
}
```

**Periods:**
- **7 kun:** Oxirgi 7 kun
- **30 kun:** Oxirgi 30 kun
- **3 oy:** Oxirgi 3 oy

### 3. Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: _loadStatistics,
  color: Color(0xFF1565C0),
)
```

### 4. Bar Chart Interaction
```dart
BarTouchData(
  enabled: true,
  touchTooltipData: BarTouchTooltipData(
    getTooltipColor: (group) => Color(0xFF1565C0),
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      return BarTooltipItem(
        '${rod.toY.toInt()} ta xona',
        GoogleFonts.poppins(...),
      );
    },
  ),
)
```

---

## 🌐 BACKEND INTEGRATION

### Required Endpoints

#### 1. Get Weekly Statistics
```
GET /api/statistics/weekly?period=7
Headers: Authorization: Bearer <token>
Query Params:
  - period: 7 | 30 | 90 (days)

Response: {
  "days": [
    {
      "date": "2026-05-05",
      "day": "Ya",
      "count": 5
    },
    {
      "date": "2026-05-04",
      "day": "Sh",
      "count": 8
    },
    ...
  ]
}
```

#### 2. Get Statistics Summary
```
GET /api/statistics/summary?period=7
Headers: Authorization: Bearer <token>
Query Params:
  - period: 7 | 30 | 90 (days)

Response: {
  "efficiency": 87.5,        // Percentage (0-100)
  "avgTime": 23.4,           // Minutes
  "total": 82,               // Total cleaned rooms
  "period": "7 kun"
}
```

### Mock Data (Development)
```dart
// Weekly data
_weeklyData = [
  {'day': 'Du', 'count': 12},
  {'day': 'Se', 'count': 15},
  {'day': 'Ch', 'count': 10},
  {'day': 'Pa', 'count': 18},
  {'day': 'Ju', 'count': 14},
  {'day': 'Sh', 'count': 8},
  {'day': 'Ya', 'count': 5},
];

// Summary
_efficiency = 87.5;
_avgTime = 23.4;
_totalCleaned = 82;
```

---

## 🎭 ANIMATSIYALAR

### 1. Screen Fade-in
- **Type:** Fade
- **Duration:** 800ms
- **Curve:** easeOut
- **Target:** Entire screen content

### 2. Metric Cards
- **Type:** Slide-up + Fade-in
- **Duration:** 600ms (Card 1), 700ms (Card 2)
- **Delay:** 0ms, 100ms
- **Curve:** easeOut
- **Offset:** (0, 20) → (0, 0)

### 3. Period Filter
- **Type:** Background transition
- **Duration:** 200ms
- **Curve:** Linear
- **Property:** Gradient color

---

## 📊 HISOBLASHLAR

### Samaradorlik (Efficiency)
```dart
// Backend formula
efficiency = (completedOnTime / totalCompleted) * 100

// Example
completedOnTime = 70
totalCompleted = 80
efficiency = (70 / 80) * 100 = 87.5%
```

### O'rtacha Vaqt (Average Time)
```dart
// Backend formula
avgTime = totalMinutes / totalCompleted

// Example
totalMinutes = 1872
totalCompleted = 80
avgTime = 1872 / 80 = 23.4 minutes
```

### Jami Tozalangan (Total Cleaned)
```dart
// Backend formula
total = COUNT(tasks WHERE status = 'COMPLETED' AND period)

// Example
total = 82 (last 7 days)
```

---

## 🎨 RESPONSIVE DIZAYN

### Padding va Spacing
- Screen padding: 20px
- Card margin: 12px (between cards)
- Section spacing: 24px
- Card padding: 20px

### Font Sizes
- AppBar title: 16px
- Filter button: 14px
- Metric value: 28px
- Metric label: 13px
- Chart title: 18px
- Chart labels: 11-12px
- Total value: 28px
- Total label: 14px

### Breakpoints
- Mobile: < 600px (default)
- Tablet: 600-900px (same layout)
- Desktop: > 900px (same layout)

---

## 🚀 NAVIGATION

### From Admin Dashboard
```dart
// Admin Panel Card
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => StatisticsScreen(),
  ),
);
```

### Back Navigation
```dart
// AppBar back button
Navigator.pop(context);
```

---

## ✨ ASOSIY XUSUSIYATLAR

✅ Dark theme dizayn  
✅ Glassmorphism cards  
✅ fl_chart BarChart integration  
✅ Period filter (7/30/90 days)  
✅ Metric cards (efficiency, avg time)  
✅ Interactive bar chart with tooltips  
✅ Pull-to-refresh  
✅ Smooth animations  
✅ Responsive layout  
✅ Professional UI/UX  
✅ Mock data support  
✅ Backend integration ready  

---

## 🔧 DEPENDENCIES

```yaml
dependencies:
  fl_chart: ^0.69.0
  google_fonts: ^6.1.0
  http: ^1.2.1
  provider: ^6.1.2
```

---

## 📱 FOYDALANUVCHI OQIMI

```
Admin Dashboard
    ↓
Tap "Statistika" card
    ↓
StatisticsScreen opens
    ↓
Load statistics (GET /api/statistics/*)
    ↓
Display:
    ├─ Period filter
    ├─ Metric cards
    ├─ Weekly chart
    └─ Total card
    ↓
User Actions:
    ├─ Change period → Reload data
    ├─ Tap bar → Show tooltip
    ├─ Pull-to-refresh → Reload data
    └─ Back button → Return to dashboard
```

---

## 🎯 TEST QILISH

### 1. Login as Admin
```
Username: admin
Password: admin123
```

### 2. Navigate to Statistics
```
Dashboard → Statistika card → Tap
```

### 3. Test Scenarios

**Scenario 1: View Statistics**
- Screen opens with default period (7 kun)
- Metric cards show efficiency and avg time
- Bar chart displays weekly data
- Total card shows total cleaned rooms

**Scenario 2: Change Period**
- Tap "30 kun" filter
- Data reloads for 30 days
- Chart updates with new data

**Scenario 3: Chart Interaction**
- Tap on any bar
- Tooltip appears showing count
- Tooltip disappears on tap outside

**Scenario 4: Pull-to-Refresh**
- Pull down screen
- Loading indicator appears
- Data refreshes

---

## 📊 CODE METRICS

- **File:** statistics_screen.dart
- **Lines:** ~600 lines
- **Widgets:** 10+ custom widgets
- **Animations:** 3 types
- **API Calls:** 2 endpoints
- **Chart Library:** fl_chart

---

## 🎨 COLOR PALETTE

```dart
// Background
Dark Background:  #0a0e1a

// Primary
Primary Blue:     #1565C0
Dark Blue:        #0D47A1

// Metrics
Success Green:    #81C784
Info Blue:        #90CAF9

// Chart
Active Bar:       #1565C0 → #0D47A1 (gradient)
Inactive Bar:     #1565C0 (opacity 0.4) → #0D47A1 (opacity 0.4)
Grid Lines:       White (opacity 0.1)
Tooltip:          #1565C0

// Text
Primary Text:     White
Secondary Text:   White (opacity 0.7)
Tertiary Text:    White (opacity 0.5)

// Borders
Card Border:      White (opacity 0.2)
Filter Border:    White (opacity 0.1)
```

---

## 📝 KELAJAKDAGI YAXSHILASHLAR

### UI/UX
1. Export to PDF/Excel
2. Date range picker
3. More chart types (LineChart, PieChart)
4. Comparison mode (week vs week)
5. Drill-down details

### Backend
1. Real-time updates (WebSocket)
2. Caching strategy
3. Pagination for large datasets
4. Advanced filters (by floor, room type)
5. Custom date ranges

### Analytics
1. Trend analysis
2. Predictive analytics
3. Performance benchmarks
4. Staff comparison
5. Room type analysis

---

**Yaratilgan Sana:** 2026-05-05  
**Versiya:** 3.2.0  
**Status:** ✅ Production Ready
