# Room Monitoring System

## 📱 Loyiha haqida

Room Monitoring System - mehmonxonalar va binolarda xonalarni nazorat qilish, tozalash vazifalarini boshqarish va inventar nazoratini amalga oshirish uchun mobil ilova.

## 🎯 Maqsad

Xonalar monitoringi va vazifalarni boshqarish jarayonini avtomatlashtirish, samaradorlikni oshirish va real-time ma'lumotlarni taqdim etish.

## 🛠️ Texnologiyalar

### Backend
- **Spring Boot 3.2.4** - Java framework
- **PostgreSQL** - Relational database
- **JWT** - Authentication
- **Spring Security** - Authorization
- **Hibernate/JPA** - ORM
- **Maven** - Build tool

### Mobile
- **Flutter 3.41.7** - Cross-platform framework
- **Dart 3.11.5** - Programming language
- **Provider** - State management
- **HTTP** - API communication
- **Shared Preferences** - Local storage

### Deployment
- **Railway** - Cloud platform
- **Docker** - Containerization
- **GitHub** - Version control

## 📊 Arxitektura

```
┌─────────────┐
│   Mobile    │
│   (Flutter) │
└──────┬──────┘
       │ HTTPS/REST API
       │
┌──────▼──────┐
│   Backend   │
│ (Spring Boot)│
└──────┬──────┘
       │ JDBC
       │
┌──────▼──────┐
│  PostgreSQL │
│  (Database) │
└─────────────┘
```

## 🗄️ Database Schema

### Users
- id (PK)
- username
- password (BCrypt hashed)
- fullName
- role (ADMIN, MANAGER, STAFF)

### Rooms
- id (PK)
- roomNumber
- type (SINGLE, DOUBLE, SUITE)
- status (CLEAN, DIRTY, OCCUPIED, MAINTENANCE)

### Tasks
- id (PK)
- title
- description
- status (PENDING, IN_PROGRESS, COMPLETED)
- priority (LOW, MEDIUM, HIGH)
- assignedTo (FK → Users)
- room (FK → Rooms)
- createdAt
- updatedAt

### InventoryItems
- id (PK)
- name
- quantity
- minQuantity
- unit
- lastUpdated

## 🔐 Authentication

JWT (JSON Web Token) asosida autentifikatsiya:
1. Foydalanuvchi login/parol yuboradi
2. Backend JWT token yaratadi
3. Token har bir so'rovda Authorization header da yuboriladi
4. Backend token ni tekshiradi va foydalanuvchi rolini aniqlaydi

## 🚀 API Endpoints

### Authentication
- `POST /api/auth/login` - Login

### Rooms
- `GET /api/rooms` - Barcha xonalar
- `GET /api/rooms/{id}` - Bitta xona
- `PATCH /api/rooms/{id}/status` - Xona statusini yangilash

### Tasks
- `GET /api/tasks` - Barcha vazifalar
- `GET /api/tasks/my` - Mening vazifalarim
- `POST /api/tasks` - Yangi vazifa yaratish
- `PATCH /api/tasks/{id}/status` - Vazifa statusini yangilash

### Inventory
- `GET /api/inventory` - Barcha inventar
- `GET /api/inventory/low-stock` - Kam qolgan inventar

## 👥 Foydalanuvchi rollari

### ADMIN
- Barcha funksiyalarga kirish
- Foydalanuvchilarni boshqarish
- Barcha vazifalarni ko'rish va tahrirlash

### MANAGER
- Xonalarni boshqarish
- Vazifalarni tayinlash
- Inventar nazorati

### STAFF
- O'ziga tayinlangan vazifalarni ko'rish
- Vazifa statusini yangilash
- Xona statusini yangilash

## 📱 Mobile Ekranlar

1. **Login Screen** - Autentifikatsiya
2. **Dashboard** - Asosiy statistika
3. **Rooms List** - Xonalar ro'yxati
4. **Room Details** - Xona tafsilotlari
5. **Tasks List** - Vazifalar ro'yxati
6. **Task Details** - Vazifa tafsilotlari
7. **Inventory** - Inventar nazorati
8. **Profile** - Foydalanuvchi profili

## 🔧 O'rnatish va ishga tushirish

### Backend
```bash
cd app
./mvnw spring-boot:run
```

### Mobile
```bash
cd mobile
flutter pub get
flutter run
```

### Production Build
```bash
# Backend
./mvnw clean package

# Mobile
flutter build apk --release
```

## 🌐 Deployment

Backend Railway platformasida deploy qilindi:
- URL: https://room-monitoring-backend-production.up.railway.app
- Database: PostgreSQL (Railway)
- Healthcheck: /actuator/health

## 📈 Kelajak rejalar

- [ ] Push notifications
- [ ] Real-time updates (WebSocket)
- [ ] Analytics dashboard
- [ ] QR code scanning
- [ ] Photo upload for rooms
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline mode

## 👨‍💻 Muallif

**[Sizning ismingiz]**
- Universitet: [Universitet nomi]
- Kafedra: [Kafedra nomi]
- Yil: 2026

## 📄 Litsenziya

Bu loyiha diplom ishi sifatida yaratilgan.

## 🙏 Minnatdorchilik

- Spring Boot jamoasiga
- Flutter jamoasiga
- Railway platformasiga
- Open source community ga
