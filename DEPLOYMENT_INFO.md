# 🚀 DEPLOYMENT INFORMATION - Smart Building Management System

## 📊 BACKEND (Railway)

### 🌐 URLs
- **Production URL:** https://room-monitoring-backend-production.up.railway.app
- **Health Check:** https://room-monitoring-backend-production.up.railway.app/actuator/health
- **API Base URL:** https://room-monitoring-backend-production.up.railway.app/api

### 🗄️ Database (PostgreSQL)
- **Host:** shuttle.proxy.rlwy.net
- **Port:** 49209
- **Database Name:** railway
- **Username:** postgres
- **Password:** DzkGNEAHsBTLCoSTWCMEuebEaCrKuShh
- **Connection String:** 
  ```
  jdbc:postgresql://shuttle.proxy.rlwy.net:49209/railway
  ```

### 🔐 JWT Configuration
- **Secret Key:** room-monitoring-secret-key-for-jwt-token-generation-minimum-256-bits
- **Token Expiration:** 86400000 ms (24 hours)

### 👥 Default Users

#### Admin User
- **Username:** admin
- **Password:** admin123
- **Role:** ADMIN
- **Permissions:** Full system access

#### Manager User
- **Username:** manager
- **Password:** manager123
- **Role:** MANAGER
- **Permissions:** Manage rooms, tasks, inventory

#### Staff User
- **Username:** staff
- **Password:** staff123
- **Role:** STAFF
- **Permissions:** View and complete assigned tasks

---

## 📱 MOBILE APP (Flutter)

### 📦 APK Information
- **Location:** mobile/build/app/outputs/flutter-apk/app-release.apk
- **Size:** 47.5 MB
- **Min SDK:** Android 21 (Lollipop 5.0)
- **Target SDK:** Android 34

### 🔗 Backend Connection
- **API Base URL:** https://room-monitoring-backend-production.up.railway.app/api
- **Configured in:** mobile/lib/services/api_service.dart

---

## 🔌 API ENDPOINTS

### Authentication
- `POST /api/auth/login` - User login
  - Request: `{ "username": "admin", "password": "admin123" }`
  - Response: `{ "token": "jwt_token", "username": "admin", "role": "ADMIN" }`

- `POST /api/auth/register` - User registration
  - Request: `{ "username": "newuser", "password": "password", "fullName": "Full Name", "role": "STAFF" }`

### Floors
- `GET /api/floors` - Get all floors
- `GET /api/floors/{id}` - Get floor by ID
- `GET /api/floors/{id}/rooms` - Get rooms on a floor
- `GET /api/floors/{id}/statistics` - Get floor statistics
- `GET /api/floors/building-stats` - Get building-wide statistics

### Rooms
- `GET /api/rooms` - Get all rooms
- `GET /api/rooms/{id}` - Get room by ID
- `POST /api/rooms` - Create new room
- `PUT /api/rooms/{id}` - Update room
- `DELETE /api/rooms/{id}` - Delete room
- `PATCH /api/rooms/{id}/status` - Update room status
- `GET /api/rooms/by-zone/{zoneType}` - Get rooms by zone

### Tasks
- `GET /api/tasks` - Get all tasks
- `GET /api/tasks/{id}` - Get task by ID
- `GET /api/tasks/my` - Get my tasks (current user)
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task
- `PATCH /api/tasks/{id}/status` - Update task status
- `PUT /api/tasks/{id}/complete` - Complete task (awards coins)
- `GET /api/tasks/ai-schedule` - Get AI-generated schedule

### Inventory
- `GET /api/inventory` - Get all inventory items
- `GET /api/inventory/{id}` - Get inventory item by ID
- `GET /api/inventory/low-stock` - Get low stock items
- `POST /api/inventory` - Create inventory item
- `PUT /api/inventory/{id}` - Update inventory item
- `GET /api/inventory/restock-alerts` - Get restock alerts
- `GET /api/inventory/predictions` - Get consumption predictions

### Leaderboard
- `GET /api/leaderboard` - Get current month leaderboard
- `GET /api/leaderboard/{month}/{year}` - Get leaderboard for specific month
- `GET /api/leaderboard/my-rank` - Get current user's rank
- `POST /api/leaderboard/award-coins` - Award coins to user (Manager only)
- `GET /api/users/{id}/coins` - Get user's coin balance

---

## 🗂️ DATABASE SCHEMA

### Tables

#### users
```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'MANAGER', 'STAFF', 'MAINTENANCE')),
    cleaning_coins INTEGER DEFAULT 0,
    tasks_completed INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### floors
```sql
CREATE TABLE floors (
    id BIGSERIAL PRIMARY KEY,
    floor_number INTEGER NOT NULL UNIQUE CHECK (floor_number >= -3 AND floor_number <= 8),
    zone_type VARCHAR(20) NOT NULL CHECK (zone_type IN ('PARKING', 'OFFICE', 'HOTEL')),
    display_name VARCHAR(100) NOT NULL,
    total_rooms INTEGER DEFAULT 0,
    clean_rooms INTEGER DEFAULT 0,
    dirty_rooms INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### rooms
```sql
CREATE TABLE rooms (
    id BIGSERIAL PRIMARY KEY,
    room_number VARCHAR(50) NOT NULL UNIQUE,
    type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('CLEAN', 'DIRTY', 'OCCUPIED', 'MAINTENANCE')),
    floor_id BIGINT REFERENCES floors(id),
    last_cleaned TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### tasks
```sql
CREATE TABLE tasks (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    room_id BIGINT REFERENCES rooms(id),
    assigned_to BIGINT REFERENCES users(id),
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    priority VARCHAR(20) NOT NULL CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);
```

#### inventory
```sql
CREATE TABLE inventory (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    min_quantity INTEGER NOT NULL,
    unit VARCHAR(20),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔧 ENVIRONMENT VARIABLES (Railway)

### Required Variables
```bash
# Database (Auto-configured by Railway)
DATABASE_URL=jdbc:postgresql://shuttle.proxy.rlwy.net:49209/railway
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=DzkGNEAHsBTLCoSTWCMEuebEaCrKuShh

# Server Port (Auto-configured by Railway)
PORT=8080

# JWT Configuration
JWT_SECRET=room-monitoring-secret-key-for-jwt-token-generation-minimum-256-bits
JWT_EXPIRATION=86400000
```

---

## 📊 SYSTEM STATISTICS

### Backend
- **Framework:** Spring Boot 3.2.4
- **Java Version:** 17
- **Database:** PostgreSQL 15
- **Deployment Platform:** Railway
- **Status:** ✅ Running

### Mobile
- **Framework:** Flutter 3.41.7
- **Dart Version:** 3.11.5
- **Platform:** Android
- **APK Size:** 47.5 MB
- **Status:** ✅ Built

### Database
- **Tables:** 5 (users, floors, rooms, tasks, inventory)
- **Default Users:** 3 (admin, manager, staff)
- **Connection Pool:** 5 connections max
- **Status:** ✅ Connected

---

## 🧪 TESTING

### Test Backend API
```bash
# Health Check
curl https://room-monitoring-backend-production.up.railway.app/actuator/health

# Login
curl -X POST https://room-monitoring-backend-production.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Get Rooms (with JWT token)
curl https://room-monitoring-backend-production.up.railway.app/api/rooms \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Test Mobile App
1. Install APK: `mobile/build/app/outputs/flutter-apk/app-release.apk`
2. Login with: admin / admin123
3. Navigate through tabs: Rooms, Tasks, Inventory, Profile

---

## 📞 SUPPORT & TROUBLESHOOTING

### Common Issues

#### Backend not responding
- Check Railway dashboard: https://railway.app/project/8a61e5e4-6353-4cc6-b44a-05a4ad4b0eba
- Check logs in Railway dashboard
- Verify database connection

#### Mobile app can't connect
- Verify backend URL in `mobile/lib/services/api_service.dart`
- Check internet connection
- Verify JWT token is valid

#### Database connection failed
- Check database credentials
- Verify database is running in Railway
- Check connection pool settings

---

## 🔐 SECURITY NOTES

### Production Security
- ✅ JWT authentication enabled
- ✅ BCrypt password hashing
- ✅ Role-based access control (RBAC)
- ✅ CORS configured
- ✅ HTTPS enabled (Railway)

### Security Recommendations
- Change default user passwords in production
- Rotate JWT secret key regularly
- Use environment variables for sensitive data
- Enable database SSL in production
- Implement rate limiting for API endpoints

---

## 📝 MAINTENANCE

### Regular Tasks
- Monitor Railway logs for errors
- Check database size and performance
- Update dependencies regularly
- Backup database weekly
- Review user access and permissions

### Backup Strategy
- Database: Railway automatic backups
- Code: GitHub repository
- APK: Stored in `mobile/build/app/outputs/flutter-apk/`

---

**Last Updated:** 2026-04-28  
**Version:** 1.0  
**Status:** ✅ Production Ready
