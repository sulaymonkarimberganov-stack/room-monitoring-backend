# Design Document: Smart Building Management System

## 1. System Architecture

### 1.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Mobile App (Flutter)                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Dashboard │  │3D Floor  │  │  Tasks   │  │Leaderboard│   │
│  │          │  │   Map    │  │          │  │          │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Profile  │  │   AR     │  │  Camera  │  │Analytics │   │
│  │          │  │ Guidance │  │  (CV)    │  │          │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTPS/REST API
                            │ WebSocket (Real-time)
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              Spring Boot Backend (Java 17)                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                  REST Controllers                     │  │
│  │  Auth│Floor│Room│Task│Inventory│Leaderboard│Analytics│  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                   Service Layer                       │  │
│  │  AI Scheduler│CV Audit│IoT│AR│Gamification│Sentiment │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                Repository Layer (JPA)                 │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ JDBC
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  PostgreSQL Database                         │
│  Tables: users, floors, rooms, tasks, inventory,            │
│          photos, reviews, resource_logs, leaderboard        │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Technology Stack

**Backend:**
- Java 17
- Spring Boot 3.2.4
- Spring Data JPA
- Spring Security + JWT
- PostgreSQL 15
- WebSocket (for real-time updates)
- Railway (deployment)

**Mobile:**
- Flutter 3.x
- Dart 3.x
- Provider (state management)
- HTTP + WebSocket
- Camera plugin
- AR Core/AR Kit (for AR features)
- Shared Preferences (offline cache)

**AI/ML Components:**
- TensorFlow Lite (for CV on mobile)
- Simple ML algorithms (for predictive scheduling)
- NLP library (for sentiment analysis)

---

## 2. Database Schema

### 2.1 Core Entities

#### 2.1.1 Floor Table
```sql
CREATE TABLE floors (
    id BIGSERIAL PRIMARY KEY,
    floor_number INTEGER NOT NULL UNIQUE CHECK (floor_number >= -3 AND floor_number <= 8),
    zone_type VARCHAR(20) NOT NULL CHECK (zone_type IN ('PARKING', 'OFFICE', 'HOTEL')),
    display_name VARCHAR(100) NOT NULL,
    total_rooms INTEGER DEFAULT 0,
    clean_rooms INTEGER DEFAULT 0,
    dirty_rooms INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_floor_zone ON floors(zone_type);
```

#### 2.1.2 Room Table (Extended)
```sql
CREATE TABLE rooms (
    id BIGSERIAL PRIMARY KEY,
    room_number VARCHAR(50) NOT NULL UNIQUE,
    type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('CLEAN', 'DIRTY', 'OCCUPIED', 'MAINTENANCE')),
    floor_id BIGINT REFERENCES floors(id),
    
    -- Parking Zone Fields
    oil_stain_present BOOLEAN DEFAULT FALSE,
    lighting_functional BOOLEAN DEFAULT TRUE,
    drainage_clear BOOLEAN DEFAULT TRUE,
    
    -- Office Zone Fields
    desk_clean BOOLEAN DEFAULT TRUE,
    meeting_room_occupied BOOLEAN DEFAULT FALSE,
    air_quality VARCHAR(20) CHECK (air_quality IN ('GOOD', 'MODERATE', 'POOR')),
    
    -- Hotel Zone Fields
    hsr_compliant BOOLEAN DEFAULT TRUE,
    minibar_stocked BOOLEAN DEFAULT TRUE,
    guest_checked_in BOOLEAN DEFAULT FALSE,
    last_checkout_at TIMESTAMP,
    last_checkin_at TIMESTAMP,
    
    last_cleaned TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_room_floor ON rooms(floor_id);
CREATE INDEX idx_room_status ON rooms(status);
```

#### 2.1.3 User Table (Extended)
```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'MANAGER', 'STAFF', 'MAINTENANCE')),
    
    -- Gamification Fields
    cleaning_coins INTEGER DEFAULT 0 CHECK (cleaning_coins >= 0),
    tasks_completed INTEGER DEFAULT 0 CHECK (tasks_completed >= 0),
    
    -- Availability Fields
    availability_status VARCHAR(20) DEFAULT 'AVAILABLE' CHECK (availability_status IN ('AVAILABLE', 'BUSY', 'OFF_DUTY')),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_role ON users(role);
CREATE INDEX idx_user_coins ON users(cleaning_coins DESC);
```

#### 2.1.4 Task Table (Extended)
```sql
CREATE TABLE tasks (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    room_id BIGINT REFERENCES rooms(id),
    assigned_to BIGINT REFERENCES users(id),
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    priority VARCHAR(20) NOT NULL CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')),
    
    -- Quality & Gamification
    cleaning_quality_score INTEGER CHECK (cleaning_quality_score >= 0 AND cleaning_quality_score <= 100),
    coins_awarded INTEGER DEFAULT 0,
    
    -- Scheduling
    scheduled_time TIMESTAMP,
    is_ai_generated BOOLEAN DEFAULT FALSE,
    is_urgent_override BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_task_assigned ON tasks(assigned_to);
CREATE INDEX idx_task_status ON tasks(status);
CREATE INDEX idx_task_room ON tasks(room_id);
CREATE INDEX idx_task_scheduled ON tasks(scheduled_time);
```

#### 2.1.5 Inventory Table (Extended)
```sql
CREATE TABLE inventory (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    min_quantity INTEGER NOT NULL,
    max_capacity INTEGER NOT NULL,
    unit VARCHAR(20),
    
    -- IoT Fields
    room_id BIGINT REFERENCES rooms(id),
    item_type VARCHAR(50) CHECK (item_type IN ('SHAMPOO', 'SOAP', 'PAPER', 'CLEANING_SUPPLY', 'OTHER')),
    restock_threshold_percentage INTEGER DEFAULT 20,
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_inventory_room ON inventory(room_id);
CREATE INDEX idx_inventory_low_stock ON inventory(quantity);
```

### 2.2 New Tables

#### 2.2.1 Photo Table
```sql
CREATE TABLE photos (
    id BIGSERIAL PRIMARY KEY,
    task_id BIGINT REFERENCES tasks(id),
    room_id BIGINT REFERENCES rooms(id),
    uploaded_by BIGINT REFERENCES users(id),
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    
    -- CV Analysis
    cv_quality_score INTEGER CHECK (cv_quality_score >= 0 AND cv_quality_score <= 100),
    cv_analysis_completed BOOLEAN DEFAULT FALSE,
    cv_analysis_result TEXT,
    
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_photo_task ON photos(task_id);
CREATE INDEX idx_photo_room ON photos(room_id);
```

#### 2.2.2 Guest Review Table
```sql
CREATE TABLE guest_reviews (
    id BIGSERIAL PRIMARY KEY,
    room_id BIGINT REFERENCES rooms(id),
    review_text TEXT NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    
    -- Sentiment Analysis
    sentiment VARCHAR(20) CHECK (sentiment IN ('POSITIVE', 'NEUTRAL', 'NEGATIVE')),
    sentiment_score DECIMAL(5,2),
    problem_areas TEXT[], -- Array of identified issues
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_review_room ON guest_reviews(room_id);
CREATE INDEX idx_review_sentiment ON guest_reviews(sentiment);
```

#### 2.2.3 Resource Log Table
```sql
CREATE TABLE resource_logs (
    id BIGSERIAL PRIMARY KEY,
    floor_id BIGINT REFERENCES floors(id),
    zone_type VARCHAR(20) NOT NULL,
    
    -- Resource Consumption
    water_consumption DECIMAL(10,2) CHECK (water_consumption >= 0), -- liters
    electricity_consumption DECIMAL(10,2) CHECK (electricity_consumption >= 0), -- kWh
    
    -- Baseline Comparison
    is_baseline BOOLEAN DEFAULT FALSE,
    waste_alert_triggered BOOLEAN DEFAULT FALSE,
    leak_detected BOOLEAN DEFAULT FALSE,
    
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_resource_floor ON resource_logs(floor_id);
CREATE INDEX idx_resource_zone ON resource_logs(zone_type);
CREATE INDEX idx_resource_time ON resource_logs(logged_at);
```

#### 2.2.4 Staff Assignment Table
```sql
CREATE TABLE staff_assignments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    floor_id BIGINT REFERENCES floors(id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, floor_id)
);

CREATE INDEX idx_assignment_user ON staff_assignments(user_id);
CREATE INDEX idx_assignment_floor ON staff_assignments(floor_id);
```

#### 2.2.5 Leaderboard Table
```sql
CREATE TABLE leaderboard (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    month INTEGER NOT NULL CHECK (month >= 1 AND month <= 12),
    year INTEGER NOT NULL,
    total_coins INTEGER DEFAULT 0,
    total_tasks INTEGER DEFAULT 0,
    average_quality_score DECIMAL(5,2),
    rank INTEGER,
    is_employee_of_month BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, month, year)
);

CREATE INDEX idx_leaderboard_month ON leaderboard(year, month);
CREATE INDEX idx_leaderboard_rank ON leaderboard(rank);
```

---

## 3. API Endpoints

### 3.1 Authentication (Existing)
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### 3.2 Floor Management (NEW)
- `GET /api/floors` - Get all floors
- `GET /api/floors/{id}` - Get floor by ID
- `GET /api/floors/{id}/rooms` - Get all rooms on a floor
- `GET /api/floors/{id}/statistics` - Get floor statistics
- `GET /api/floors/building-stats` - Get building-wide statistics

### 3.3 Room Management (Extended)
- `GET /api/rooms` - Get all rooms (with floor filter)
- `GET /api/rooms/{id}` - Get room by ID
- `POST /api/rooms` - Create new room
- `PUT /api/rooms/{id}` - Update room
- `DELETE /api/rooms/{id}` - Delete room
- `PUT /api/rooms/{id}/status` - Update room status
- `GET /api/rooms/by-zone/{zoneType}` - Get rooms by zone

### 3.4 Task Management (Extended)
- `GET /api/tasks` - Get all tasks (with filters)
- `GET /api/tasks/{id}` - Get task by ID
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task
- `PUT /api/tasks/{id}/complete` - Complete task (awards coins)
- `GET /api/tasks/my-tasks` - Get tasks for current user
- `GET /api/tasks/ai-schedule` - Get AI-generated schedule

### 3.5 Inventory Management (Extended)
- `GET /api/inventory` - Get all inventory items
- `GET /api/inventory/{id}` - Get inventory item by ID
- `POST /api/inventory` - Create inventory item
- `PUT /api/inventory/{id}` - Update inventory item
- `GET /api/inventory/low-stock` - Get low stock items
- `GET /api/inventory/restock-alerts` - Get restock alerts
- `GET /api/inventory/predictions` - Get consumption predictions

### 3.6 Gamification & Leaderboard (NEW)
- `GET /api/leaderboard` - Get current month leaderboard
- `GET /api/leaderboard/{month}/{year}` - Get leaderboard for specific month
- `GET /api/leaderboard/my-rank` - Get current user's rank
- `POST /api/leaderboard/award-coins` - Award coins to user (Manager only)
- `GET /api/users/{id}/coins` - Get user's coin balance

### 3.7 Photo & Computer Vision (NEW)
- `POST /api/photos/upload` - Upload photo for task
- `GET /api/photos/task/{taskId}` - Get photos for task
- `GET /api/photos/room/{roomId}` - Get photos for room
- `POST /api/photos/{id}/analyze` - Trigger CV analysis

### 3.8 Guest Reviews & Sentiment (NEW)
- `POST /api/reviews` - Submit guest review
- `GET /api/reviews/room/{roomId}` - Get reviews for room
- `GET /api/reviews/sentiment-summary` - Get sentiment summary
- `GET /api/reviews/problem-heatmap` - Get problem heatmap data

### 3.9 Resource Management (NEW)
- `POST /api/resources/log` - Log resource consumption
- `GET /api/resources/consumption` - Get consumption data
- `GET /api/resources/waste-alerts` - Get waste alerts
- `GET /api/resources/leak-alerts` - Get leak detection alerts
- `GET /api/resources/waste-reduction` - Get waste reduction percentage

### 3.10 Analytics (NEW)
- `GET /api/analytics/dashboard` - Get admin dashboard data
- `GET /api/analytics/quality-score` - Get system-wide quality score
- `GET /api/analytics/completion-rate` - Get task completion rate
- `GET /api/analytics/trends` - Get performance trends

### 3.11 Staff Management (NEW)
- `GET /api/staff/available` - Get available staff
- `GET /api/staff/{id}/assignments` - Get staff floor assignments
- `POST /api/staff/{id}/assign-floor` - Assign staff to floor
- `PUT /api/staff/{id}/availability` - Update staff availability

---

## 4. Mobile App Design

### 4.1 Screen Structure

```
Login Screen
    │
    ├─> Dashboard (4 tabs)
    │   ├─> Rooms Tab
    │   │   └─> Room Detail
    │   │       ├─> Update Status
    │   │       ├─> View Photos
    │   │       └─> AR Guidance
    │   ├─> Tasks Tab
    │   │   └─> Task Detail
    │   │       ├─> Complete Task
    │   │       ├─> Upload Photo
    │   │       └─> View Quality Score
    │   ├─> Inventory Tab
    │   │   └─> Inventory Detail
    │   │       └─> Update Quantity
    │   └─> Profile Tab
    │       ├─> View Coins
    │       ├─> View Rank
    │       └─> Logout
    │
    ├─> 3D Floor Map Screen (NEW)
    │   ├─> Vertical building view
    │   ├─> Floor selection
    │   └─> Navigate to floor detail
    │
    ├─> Leaderboard Screen (NEW)
    │   ├─> Top 10 users
    │   ├─> My rank
    │   └─> Monthly history
    │
    ├─> Analytics Screen (Admin only) (NEW)
    │   ├─> Quality score chart
    │   ├─> Completion rate
    │   ├─> Resource consumption
    │   └─> Problem heatmap
    │
    └─> AR Guidance Screen (NEW)
        ├─> Camera view
        ├─> AR overlays
        └─> Step-by-step instructions
```

### 4.2 Color Coding by Zone

**Parking Zone (Floors -3 to -1):**
- Primary: Gray (#607D8B)
- Secondary: Blue (#2196F3)

**Office Zone (Floors 1 to 3):**
- Primary: White (#FFFFFF)
- Secondary: Yellow (#FFC107)

**Hotel Zone (Floors 4 to 8):**
- Primary: Gold (#FFD700)
- Secondary: Green (#4CAF50)

### 4.3 Key UI Components

#### 4.3.1 3D Floor Map Widget
```dart
class FloorMapWidget extends StatelessWidget {
  // Displays vertical 3D building
  // Color-coded by zone
  // Interactive floor selection
  // Real-time status updates
}
```

#### 4.3.2 Leaderboard Widget
```dart
class LeaderboardWidget extends StatelessWidget {
  // Top 10 users list
  // User rank display
  // Coin balance
  // Employee of the Month badge
}
```

#### 4.3.3 AR Guidance Widget
```dart
class ARGuidanceWidget extends StatefulWidget {
  // Camera view
  // AR overlay rendering
  // Step-by-step instructions
  // Context-aware guidance
}
```

---

## 5. Service Layer Design

### 5.1 AI Scheduler Service

```java
@Service
public class AISchedulerService {
    
    // Analyze historical check-in/check-out patterns
    public List<Task> generateOptimizedSchedule(LocalDate date);
    
    // Optimize cleaning routes across floors
    public List<Task> optimizeRoutes(List<Task> tasks);
    
    // Apply Silent Cleaning Algorithm for office zones
    public List<Task> applySilentCleaningRules(List<Task> tasks);
    
    // Consider staff availability
    public boolean isStaffAvailable(User staff, LocalDateTime time);
}
```

### 5.2 Computer Vision Service

```java
@Service
public class CVAuditService {
    
    // Analyze uploaded photo
    public CVAnalysisResult analyzePhoto(MultipartFile photo, Room room);
    
    // Calculate cleaning quality score (0-100)
    public int calculateQualityScore(BufferedImage image);
    
    // Compare with template images
    public boolean compareWithTemplate(BufferedImage uploaded, BufferedImage template);
    
    // Flag low-quality tasks for review
    public void flagForReview(Task task, int qualityScore);
}
```

### 5.3 Gamification Service

```java
@Service
public class GamificationService {
    
    // Award coins for completed task
    public void awardCoins(User user, Task task, int qualityScore);
    
    // Calculate coin amount based on complexity and quality
    public int calculateCoinReward(Task task, int qualityScore);
    
    // Update leaderboard
    public void updateLeaderboard(User user, int coins);
    
    // Determine Employee of the Month
    public User getEmployeeOfMonth(int month, int year);
}
```

### 5.4 Sentiment Analysis Service

```java
@Service
public class SentimentAnalysisService {
    
    // Analyze review text
    public SentimentResult analyzeReview(String reviewText);
    
    // Extract mentioned rooms/areas
    public List<Room> extractMentionedRooms(String reviewText);
    
    // Generate problem heatmap data
    public Map<Floor, Integer> generateProblemHeatmap();
    
    // Trigger alerts for high negative sentiment
    public void checkSentimentThreshold(Room room);
}
```

### 5.5 Resource Monitor Service

```java
@Service
public class ResourceMonitorService {
    
    // Track water and electricity consumption
    public void logResourceConsumption(Floor floor, double water, double electricity);
    
    // Calculate baseline consumption
    public void calculateBaseline();
    
    // Detect waste (30% above baseline)
    public void detectWaste();
    
    // Detect potential leaks
    public void detectLeaks();
    
    // Calculate waste reduction percentage
    public double getWasteReductionPercentage();
}
```

### 5.6 IoT Inventory Service

```java
@Service
public class IoTInventoryService {
    
    // Track inventory levels
    public void updateInventoryLevel(InventoryItem item, int quantity);
    
    // Check restock threshold (20%)
    public List<InventoryItem> getRestockAlerts();
    
    // Predict monthly consumption
    public Map<InventoryItem, Double> predictMonthlyConsumption();
    
    // Generate restock alerts
    public void generateRestockAlert(InventoryItem item);
}
```

---

## 6. Real-Time Updates

### 6.1 WebSocket Configuration

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws").setAllowedOrigins("*").withSockJS();
    }
}
```

### 6.2 Real-Time Events

- Room status change → Broadcast to `/topic/rooms/{roomId}`
- Task status change → Broadcast to `/topic/tasks/{taskId}`
- Floor statistics update → Broadcast to `/topic/floors/{floorId}`
- Leaderboard update → Broadcast to `/topic/leaderboard`
- Resource alert → Broadcast to `/topic/alerts`

---

## 7. Offline Mode Design

### 7.1 Mobile App Caching Strategy

```dart
class OfflineCache {
  // Cache user's assigned tasks
  Future<void> cacheMyTasks(List<Task> tasks);
  
  // Cache floor and room data
  Future<void> cacheFloorData(List<Floor> floors);
  
  // Queue pending updates
  Future<void> queueUpdate(String endpoint, Map<String, dynamic> data);
  
  // Sync when online
  Future<void> syncPendingUpdates();
  
  // Check connectivity
  bool isOnline();
}
```

### 7.2 Offline Capabilities

**Allowed in Offline Mode:**
- View assigned tasks
- View room details
- View floor information
- View cached photos

**Not Allowed in Offline Mode:**
- Update task status
- Upload photos
- Update room status
- View real-time updates

---

## 8. Security & Authorization

### 8.1 Role-Based Access Control

| Endpoint | Admin | Manager | Staff | Maintenance |
|----------|-------|---------|-------|-------------|
| View all floors | ✓ | ✓ | ✓ | ✓ |
| View all rooms | ✓ | ✓ | ✓ | ✓ |
| Create/Edit rooms | ✓ | ✓ | ✗ | ✗ |
| View all tasks | ✓ | ✓ | Own only | Own only |
| Create tasks | ✓ | ✓ | ✗ | ✗ |
| Complete tasks | ✓ | ✓ | ✓ | ✓ |
| View leaderboard | ✓ | ✓ | ✓ | ✓ |
| Award coins | ✓ | ✓ | ✗ | ✗ |
| View analytics | ✓ | ✗ | ✗ | ✗ |
| Manage inventory | ✓ | ✓ | ✗ | ✗ |
| View resource logs | ✓ | ✓ | ✗ | ✓ |

---

## 9. Performance Requirements

### 9.1 Response Time Targets

- API endpoints: < 500ms (95th percentile)
- Real-time updates: < 2 seconds
- Photo upload: < 5 seconds
- CV analysis: < 5 seconds
- AI schedule generation: < 5 seconds

### 9.2 Scalability

- Support 10-15 concurrent users
- Handle 95 monitoring points
- Store 12 months of historical data
- Support 100+ daily tasks

### 9.3 Mobile App Performance

- App size: < 100 MB
- Startup time: < 3 seconds
- AR frame rate: ≥ 15 FPS
- Offline mode: Full task viewing

---

## 10. Data Migration Strategy

### 10.1 Backward Compatibility

**Existing Tables to Preserve:**
- `users` table (add new fields only)
- `rooms` table (add new fields only)
- `tasks` table (add new fields only)
- `inventory` table (add new fields only)

**New Tables to Create:**
- `floors`
- `photos`
- `guest_reviews`
- `resource_logs`
- `staff_assignments`
- `leaderboard`

### 10.2 Migration Steps

1. Create `floors` table
2. Add `floor_id` to `rooms` table
3. Create default floors (-3 to 8)
4. Assign existing rooms to appropriate floors
5. Add new fields to `users` table (cleaningCoins, tasksCompleted, availabilityStatus)
6. Add new fields to `rooms` table (zone-specific fields)
7. Add new fields to `tasks` table (qualityScore, coinsAwarded, scheduledTime)
8. Create new tables (photos, guest_reviews, resource_logs, etc.)
9. Update API endpoints to support new fields
10. Deploy mobile app with new features

---

## 11. Testing Strategy

### 11.1 Backend Testing

- Unit tests for all service methods
- Integration tests for API endpoints
- Database migration tests
- Performance tests for AI scheduler
- Load tests for concurrent users

### 11.2 Mobile Testing

- Widget tests for UI components
- Integration tests for API calls
- Offline mode tests
- AR functionality tests
- Performance tests (app size, startup time)

### 11.3 End-to-End Testing

- User authentication flow
- Task creation and completion flow
- Photo upload and CV analysis flow
- Leaderboard update flow
- Real-time update flow

---

## 12. Deployment Strategy

### 12.1 Backend Deployment (Railway)

1. Update `application.properties` with production database
2. Build Docker image
3. Push to Railway
4. Run database migrations
5. Verify API endpoints
6. Monitor logs

### 12.2 Mobile Deployment

1. Build release APK
2. Test on physical devices
3. Verify offline mode
4. Verify AR features
5. Check app size (< 100 MB)
6. Distribute to users

---

## 13. Future Enhancements

### 13.1 Phase 2 Features (Post-MVP)

- Push notifications for task assignments
- Voice commands for hands-free operation
- Advanced AI predictions using machine learning
- Integration with actual IoT sensors
- Multi-language support
- Dark mode
- Export reports to PDF
- Integration with building management systems

### 13.2 Scalability Improvements

- Microservices architecture
- Redis caching layer
- CDN for photo storage
- Horizontal scaling with load balancer
- Database read replicas

---

## 14. Glossary Reference

All technical terms used in this design document are defined in the Requirements Document glossary section.

---

**Document Version:** 1.0  
**Last Updated:** 2026-04-28  
**Status:** Ready for Implementation
