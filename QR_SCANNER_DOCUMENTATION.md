# 📱 QR Kod Skaneri - To'liq Dokumentatsiya

## 📋 Umumiy Ma'lumot

Cleaner rollari uchun QR kod skaneri yaratildi. Xodimlar xona eshigidagi QR kodni skanerlash orqali tezda tozalashni boshlashlari mumkin.

---

## 🎨 DIZAYN XUSUSIYATLARI

### Dark Theme
```dart
Background: #0a0e1a (dark blue-black)
Primary:    #1565C0 (ko'k)
Success:    #4CAF50 (yashil)
Error:      #EF5350 (qizil)
Warning:    #FFA726 (to'q sariq)
```

### Scanner Overlay
- **Background:** Black opacity 0.5
- **Frame Size:** 280x280px
- **Frame Border:** White opacity 0.3, 2px
- **Corner Lines:** White, 4px, 40x40px
- **Border Radius:** 24px

### Room Info Card
- **Glassmorphism:** Blur (sigmaX: 10, sigmaY: 10)
- **Background:** White gradient (opacity 0.15 → 0.05)
- **Border:** White opacity 0.2, 1.5px
- **Border Radius:** 24px
- **Padding:** 24px

---

## 📱 EKRAN KOMPONENTLARI

### 1. Scanner Screen
```
┌─────────────────────────────────────────┐
│ [←] QR Skanerlash                       │
├─────────────────────────────────────────┤
│                                         │
│         ┌─────────────┐                 │
│         │             │                 │
│         │   CAMERA    │                 │
│         │             │                 │
│         └─────────────┘                 │
│                                         │
│   Kamerani QR kodga yo'naltiring        │
│                                         │
└─────────────────────────────────────────┘
```

**Scanner Frame:**
- Size: 280x280px
- 4 burchakda oq chiziqlar (40x40px)
- Markazda shaffof maydon
- Instruction text: "Kamerani QR kodga yo'naltiring"

### 2. Room Info Card (After Scan)
```
┌─────────────────────────────────────────┐
│         [QR Icon]                       │
│                                         │
│         Xona 205                        │
│         Standart                        │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ [📊] Qavat        2               │  │
│  │ [ℹ️] Holat        Tozalanmagan    │  │
│  └───────────────────────────────────┘  │
│                                         │
│  [Bekor qilish] [Tozalashni boshlash]  │
└─────────────────────────────────────────┘
```

**Components:**
- QR Icon: 80x80px, ko'k background
- Room Number: 32px, bold, white
- Room Type: 16px, white opacity 0.7
- Info Container: White opacity 0.05 background
- Action Buttons: Outlined + Gradient

### 3. Success Animation
```
┌─────────────────────────────────────────┐
│                                         │
│         [✓ Check Icon]                  │
│                                         │
│      Tozalash boshlandi!                │
│         Xona 205                        │
│                                         │
└─────────────────────────────────────────┘
```

**Animation:**
- Check icon: Scale animation (0 → 1, 600ms)
- Background: Dark (#0a0e1a)
- Border: Green (#4CAF50) opacity 0.5
- Auto-close: 2 seconds

---

## ⚙️ FUNKSIONALLIK

### 1. QR Kod Formati
```json
{
  "roomId": "123",
  "roomNumber": "205"
}
```

**Validation:**
- roomId: Required, integer
- roomNumber: Required, string

### 2. Skanerlash Jarayoni
```dart
1. User taps QR scanner button
2. Camera opens with overlay
3. User scans QR code
4. Parse JSON data
5. Validate roomId and roomNumber
6. Fetch room details from backend
7. Show room info card
8. User taps "Tozalashni boshlash"
9. Update room status to CLEANING
10. Show success animation
11. Auto-close and return
```

### 3. API Calls

#### Get Room Details
```dart
// After scanning QR
final rooms = await api.getRooms();
final room = rooms.firstWhere(
  (r) => r['id'].toString() == roomId.toString(),
);
```

#### Start Cleaning
```dart
PATCH /api/rooms/{roomId}/status
Body: { "status": "OCCUPIED" }

// OCCUPIED = CLEANING status
```

### 4. Error Handling

**QR Format Error:**
```dart
if (roomId == null || roomNumber == null) {
  _showError('QR kod noto\'g\'ri formatda');
  _resetScanner();
}
```

**Room Not Found:**
```dart
if (room == null) {
  _showError('Xona topilmadi');
  _resetScanner();
}
```

**API Error:**
```dart
catch (e) {
  _showError('Xatolik yuz berdi');
  setState(() => _isProcessing = false);
}
```

---

## 🎭 ANIMATSIYALAR

### 1. Room Info Card
- **Type:** Scale animation
- **Duration:** 600ms
- **Curve:** easeOut
- **Scale:** 0.8 → 1.0

### 2. Success Dialog
- **Type:** Scale animation
- **Duration:** 600ms
- **Curve:** Linear
- **Scale:** 0 → 1
- **Auto-close:** 2 seconds

---

## 🔄 STATE MANAGEMENT

### States
```dart
bool _isScanning = true;      // Camera is active
bool _isProcessing = false;   // Processing QR or API call
Map? _scannedRoom = null;     // Scanned room data
```

### State Flow
```
Initial State:
  _isScanning = true
  _isProcessing = false
  _scannedRoom = null

After Scan:
  _isScanning = false
  _isProcessing = false
  _scannedRoom = {...}

Processing:
  _isScanning = false
  _isProcessing = true
  _scannedRoom = {...}

Reset:
  _isScanning = true
  _isProcessing = false
  _scannedRoom = null
```

---

## 📱 NAVIGATION

### From Cleaner Dashboard
```dart
// Header QR button
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => QRScannerScreen(),
  ),
);
```

### Return After Success
```dart
// Auto-close after 2 seconds
Navigator.pop(context); // Close success dialog
Navigator.pop(context, true); // Return to dashboard
```

### Cancel
```dart
// User taps "Bekor qilish"
_resetScanner(); // Reset to scanner mode
```

---

## 🎨 UI COMPONENTS

### Scanner Overlay
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.5),
  ),
  child: Stack(
    children: [
      // Scanner frame (280x280)
      // Corner decorations (4 corners)
      // Instruction text
    ],
  ),
)
```

### Corner Decorations
```dart
// Top-left
Container(
  width: 40,
  height: 40,
  decoration: BoxDecoration(
    border: Border(
      top: BorderSide(color: Colors.white, width: 4),
      left: BorderSide(color: Colors.white, width: 4),
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
    ),
  ),
)
```

### Room Info Row
```dart
Row(
  children: [
    Icon(icon, color: white opacity 0.5, size: 20),
    SizedBox(width: 12),
    Text(label, color: white opacity 0.6),
    Spacer(),
    Text(value, color: valueColor, bold),
  ],
)
```

### Action Buttons
```dart
Row(
  children: [
    // Cancel button (outlined)
    Expanded(
      child: OutlinedButton(...),
    ),
    SizedBox(width: 12),
    // Start button (gradient)
    Expanded(
      flex: 2,
      child: ElevatedButton(
        gradient: #1565C0 → #0D47A1,
      ),
    ),
  ],
)
```

---

## 🔐 PERMISSIONS

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>QR kod skanerlash uchun kamera kerak</string>
```

---

## 📊 QR KOD YARATISH

### Backend Example (Node.js)
```javascript
const QRCode = require('qrcode');

const generateRoomQR = async (roomId, roomNumber) => {
  const data = JSON.stringify({
    roomId: roomId.toString(),
    roomNumber: roomNumber
  });
  
  const qrCode = await QRCode.toDataURL(data);
  return qrCode; // Base64 image
};
```

### Python Example
```python
import qrcode
import json

def generate_room_qr(room_id, room_number):
    data = json.dumps({
        "roomId": str(room_id),
        "roomNumber": room_number
    })
    
    qr = qrcode.QRCode(version=1, box_size=10, border=5)
    qr.add_data(data)
    qr.make(fit=True)
    
    img = qr.make_image(fill_color="black", back_color="white")
    return img
```

---

## 🧪 TEST QILISH

### 1. Generate Test QR Code
```json
{
  "roomId": "1",
  "roomNumber": "101"
}
```

Online QR Generator: https://www.qr-code-generator.com/

### 2. Test Scenarios

**Scenario 1: Successful Scan**
1. Open Cleaner Dashboard
2. Tap QR scanner button
3. Scan valid QR code
4. Room info appears
5. Tap "Tozalashni boshlash"
6. Success animation shows
7. Auto-return to dashboard

**Scenario 2: Invalid QR Format**
1. Scan QR with invalid JSON
2. Error message: "QR kod noto'g'ri formatda"
3. Scanner resets

**Scenario 3: Room Not Found**
1. Scan QR with non-existent roomId
2. Error message: "Xona topilmadi"
3. Scanner resets

**Scenario 4: Cancel**
1. Scan valid QR
2. Room info appears
3. Tap "Bekor qilish"
4. Return to scanner mode

---

## 📦 DEPENDENCIES

```yaml
mobile_scanner: ^5.0.0  # QR code scanner
google_fonts: ^6.1.0    # Poppins font
http: ^1.2.1            # API calls
```

---

## ✨ ASOSIY XUSUSIYATLAR

✅ QR kod skanerlash  
✅ Real-time camera preview  
✅ Custom scanner overlay  
✅ 4 burchakli frame dizayni  
✅ JSON parsing va validation  
✅ Room details display  
✅ Glassmorphism card  
✅ Success animation  
✅ Error handling  
✅ Auto-close va return  
✅ State management  
✅ Permission handling  

---

## 🎯 FOYDALANUVCHI OQIMI

```
Cleaner Dashboard
    ↓
Tap QR Scanner Button
    ↓
Camera Opens (Scanner Overlay)
    ↓
Scan QR Code
    ↓
Parse JSON → Validate
    ↓
Fetch Room Details
    ↓
Show Room Info Card
    ↓
User Actions:
    ├─ Bekor qilish → Reset Scanner
    └─ Tozalashni boshlash → Start Cleaning
        ↓
    Update Room Status (CLEANING)
        ↓
    Show Success Animation
        ↓
    Auto-close (2s)
        ↓
    Return to Dashboard
```

---

## 🔧 TROUBLESHOOTING

### Camera Not Working
```dart
// Check permissions
// Android: AndroidManifest.xml
// iOS: Info.plist
```

### QR Not Detected
```dart
// Check QR code quality
// Ensure good lighting
// Hold camera steady
```

### JSON Parse Error
```dart
// Validate QR format
// Check JSON structure
// Ensure proper encoding
```

---

## 📝 KELAJAKDAGI YAXSHILASHLAR

### Features
1. Flashlight toggle
2. Manual room ID input
3. QR history
4. Offline mode
5. Batch scanning

### UI/UX
1. Scanning animation
2. Sound feedback
3. Haptic feedback
4. Tutorial overlay
5. Dark/Light mode toggle

---

**Yaratilgan Sana:** 2026-05-05  
**Versiya:** 3.3.0  
**Status:** ✅ Production Ready
