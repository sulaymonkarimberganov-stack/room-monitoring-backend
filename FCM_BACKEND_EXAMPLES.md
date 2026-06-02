# FCM Backend Integration - Java/Spring Boot Misollari

## 📦 Dependencies (pom.xml)

```xml
<dependencies>
    <!-- Firebase Admin SDK -->
    <dependency>
        <groupId>com.google.firebase</groupId>
        <artifactId>firebase-admin</artifactId>
        <version>9.2.0</version>
    </dependency>
</dependencies>
```

## 🔧 Firebase Initialization

### FirebaseConfig.java

```java
package Mobil.app.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void initialize() throws IOException {
        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(
                    new ClassPathResource("firebase-service-account.json").getInputStream()
                ))
                .build();

            FirebaseApp.initializeApp(options);
            System.out.println("Firebase initialized successfully");
        }
    }
}
```

**Note**: `firebase-service-account.json` faylini Firebase Console dan yuklab oling:
1. Project Settings → Service Accounts
2. "Generate new private key"
3. Faylni `src/main/resources/` ga joylashtiring

## 📱 FCM Service

### FCMService.java

```java
package Mobil.app.service;

import com.google.firebase.messaging.*;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class FCMService {

    /**
     * Bitta foydalanuvchiga notification yuborish
     */
    public String sendNotificationToUser(String fcmToken, String title, String body, Map<String, String> data) {
        try {
            Message message = Message.builder()
                .setNotification(Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build())
                .putAllData(data != null ? data : new HashMap<>())
                .setToken(fcmToken)
                .setAndroidConfig(AndroidConfig.builder()
                    .setNotification(AndroidNotification.builder()
                        .setColor("#1565C0")
                        .setSound("default")
                        .setPriority(AndroidNotification.Priority.HIGH)
                        .build())
                    .build())
                .build();

            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message: " + response);
            return response;
        } catch (FirebaseMessagingException e) {
            System.err.println("Error sending message: " + e.getMessage());
            throw new RuntimeException("Failed to send notification", e);
        }
    }

    /**
     * Topic orqali notification yuborish (rol bo'yicha)
     */
    public String sendNotificationToTopic(String topic, String title, String body, Map<String, String> data) {
        try {
            Message message = Message.builder()
                .setNotification(Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build())
                .putAllData(data != null ? data : new HashMap<>())
                .setTopic(topic)
                .setAndroidConfig(AndroidConfig.builder()
                    .setNotification(AndroidNotification.builder()
                        .setColor("#1565C0")
                        .setSound("default")
                        .setPriority(AndroidNotification.Priority.HIGH)
                        .build())
                    .build())
                .build();

            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message to topic: " + response);
            return response;
        } catch (FirebaseMessagingException e) {
            System.err.println("Error sending message to topic: " + e.getMessage());
            throw new RuntimeException("Failed to send notification to topic", e);
        }
    }

    /**
     * Ko'p foydalanuvchilarga notification yuborish
     */
    public BatchResponse sendNotificationToMultipleUsers(List<String> fcmTokens, String title, String body, Map<String, String> data) {
        try {
            MulticastMessage message = MulticastMessage.builder()
                .setNotification(Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build())
                .putAllData(data != null ? data : new HashMap<>())
                .addAllTokens(fcmTokens)
                .setAndroidConfig(AndroidConfig.builder()
                    .setNotification(AndroidNotification.builder()
                        .setColor("#1565C0")
                        .setSound("default")
                        .setPriority(AndroidNotification.Priority.HIGH)
                        .build())
                    .build())
                .build();

            BatchResponse response = FirebaseMessaging.getInstance().sendMulticast(message);
            System.out.println("Successfully sent " + response.getSuccessCount() + " messages");
            return response;
        } catch (FirebaseMessagingException e) {
            System.err.println("Error sending multicast message: " + e.getMessage());
            throw new RuntimeException("Failed to send notifications", e);
        }
    }
}
```

## 🎯 Notification Controller

### NotificationController.java

```java
package Mobil.app.controller;

import Mobil.app.service.FCMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private FCMService fcmService;

    /**
     * Test notification yuborish
     */
    @PostMapping("/send-test")
    public ResponseEntity<?> sendTestNotification(@RequestBody Map<String, String> request) {
        String fcmToken = request.get("fcmToken");
        String title = request.getOrDefault("title", "Test Notification");
        String body = request.getOrDefault("body", "Bu test bildirishnomasi");

        Map<String, String> data = new HashMap<>();
        data.put("type", "TEST");

        String response = fcmService.sendNotificationToUser(fcmToken, title, body, data);
        return ResponseEntity.ok(Map.of("success", true, "messageId", response));
    }

    /**
     * Rol bo'yicha notification yuborish
     */
    @PostMapping("/send-to-role")
    public ResponseEntity<?> sendToRole(@RequestBody Map<String, String> request) {
        String role = request.get("role"); // ADMIN, MANAGER, CLEANER
        String title = request.get("title");
        String body = request.get("body");

        Map<String, String> data = new HashMap<>();
        data.put("type", request.getOrDefault("type", "GENERAL"));

        String topic = "role_" + role.toLowerCase();
        String response = fcmService.sendNotificationToTopic(topic, title, body, data);
        return ResponseEntity.ok(Map.of("success", true, "messageId", response));
    }

    /**
     * Barcha foydalanuvchilarga notification yuborish
     */
    @PostMapping("/send-to-all")
    public ResponseEntity<?> sendToAll(@RequestBody Map<String, String> request) {
        String title = request.get("title");
        String body = request.get("body");

        Map<String, String> data = new HashMap<>();
        data.put("type", request.getOrDefault("type", "GENERAL"));

        String response = fcmService.sendNotificationToTopic("all_users", title, body, data);
        return ResponseEntity.ok(Map.of("success", true, "messageId", response));
    }
}
```

## 👤 User Controller (FCM Token)

### UserController.java

```java
package Mobil.app.controller;

import Mobil.app.entity.User;
import Mobil.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    /**
     * FCM token ni saqlash
     */
    @PostMapping("/fcm-token")
    public ResponseEntity<?> saveFCMToken(
            @RequestBody Map<String, String> request,
            Authentication authentication) {
        
        String fcmToken = request.get("fcmToken");
        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));

        user.setFcmToken(fcmToken);
        userRepository.save(user);

        return ResponseEntity.ok(Map.of("success", true, "message", "FCM token saved"));
    }

    /**
     * FCM token ni o'chirish (logout)
     */
    @DeleteMapping("/fcm-token")
    public ResponseEntity<?> deleteFCMToken(Authentication authentication) {
        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));

        user.setFcmToken(null);
        userRepository.save(user);

        return ResponseEntity.ok(Map.of("success", true, "message", "FCM token deleted"));
    }
}
```

## 🏠 Room Service (Vazifa Biriktirilganda)

### RoomService.java

```java
package Mobil.app.service;

import Mobil.app.entity.Task;
import Mobil.app.entity.User;
import Mobil.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class RoomService {

    @Autowired
    private FCMService fcmService;

    @Autowired
    private UserRepository userRepository;

    /**
     * Xodimga yangi vazifa biriktirilganda notification yuborish
     */
    public void notifyCleanerNewTask(Task task, User cleaner) {
        if (cleaner.getFcmToken() != null) {
            String title = "Yangi vazifa";
            String body = task.getRoom().getRoomNumber() + "-xona tozalanishi kerak";

            Map<String, String> data = new HashMap<>();
            data.put("type", "NEW_TASK");
            data.put("taskId", task.getId().toString());
            data.put("roomNumber", task.getRoom().getRoomNumber());

            fcmService.sendNotificationToUser(cleaner.getFcmToken(), title, body, data);
        }
    }

    /**
     * Menejarga vazifa tugallanganini bildirish
     */
    public void notifyManagerTaskCompleted(Task task) {
        String title = "Vazifa tugallandi";
        String body = task.getRoom().getRoomNumber() + "-xona tozalandi — tasdiqlash kerak";

        Map<String, String> data = new HashMap<>();
        data.put("type", "TASK_COMPLETED");
        data.put("taskId", task.getId().toString());
        data.put("roomNumber", task.getRoom().getRoomNumber());
        data.put("cleanerId", task.getAssignedTo().getId().toString());

        // Barcha menejerga yuborish
        fcmService.sendNotificationToTopic("role_manager", title, body, data);
    }
}
```

## 📦 Inventory Service (Zaxira Kam Qolganda)

### InventoryService.java

```java
package Mobil.app.service;

import Mobil.app.entity.InventoryItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class InventoryService {

    @Autowired
    private FCMService fcmService;

    /**
     * Adminga zaxira kam qolganini bildirish
     */
    public void notifyAdminLowStock(InventoryItem item) {
        // Agar zaxira 10% dan kam bo'lsa
        if (item.getQuantity() <= item.getMinQuantity()) {
            String title = "Zaxira kam qoldi";
            String body = item.getName() + " zaxirasi kam qoldi (" + item.getQuantity() + " ta)";

            Map<String, String> data = new HashMap<>();
            data.put("type", "LOW_STOCK");
            data.put("itemId", item.getId().toString());
            data.put("itemName", item.getName());
            data.put("quantity", item.getQuantity().toString());

            // Barcha adminga yuborish
            fcmService.sendNotificationToTopic("role_admin", title, body, data);
        }
    }

    /**
     * Zaxira yangilanganda tekshirish
     */
    public void updateInventory(Long itemId, Integer newQuantity) {
        InventoryItem item = inventoryRepository.findById(itemId)
            .orElseThrow(() -> new RuntimeException("Item not found"));

        item.setQuantity(newQuantity);
        inventoryRepository.save(item);

        // Agar kam qolgan bo'lsa notification yuborish
        notifyAdminLowStock(item);
    }
}
```

## 👥 User Service (Yangi Foydalanuvchi)

### UserService.java

```java
package Mobil.app.service;

import Mobil.app.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {

    @Autowired
    private FCMService fcmService;

    /**
     * Yangi foydalanuvchi qo'shilganda barcha rollarga bildirish
     */
    public void notifyNewUser(User newUser) {
        String title = "Yangi foydalanuvchi";
        String body = "Tizimga yangi foydalanuvchi qo'shildi: " + newUser.getUsername();

        Map<String, String> data = new HashMap<>();
        data.put("type", "NEW_USER");
        data.put("userId", newUser.getId().toString());
        data.put("username", newUser.getUsername());

        // Barcha foydalanuvchilarga yuborish
        fcmService.sendNotificationToTopic("all_users", title, body, data);
    }

    /**
     * Foydalanuvchi yaratish
     */
    public User createUser(User user) {
        User savedUser = userRepository.save(user);
        
        // Notification yuborish
        notifyNewUser(savedUser);
        
        return savedUser;
    }
}
```

## 🗄️ User Entity (FCM Token Field)

### User.java

```java
package Mobil.app.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String password;
    private String role; // ADMIN, MANAGER, CLEANER
    private String status;
    
    // FCM Token field
    @Column(length = 500)
    private String fcmToken;
    
    // Other fields...
}
```

## 📊 Scheduled Notifications

### NotificationScheduler.java

```java
package Mobil.app.scheduler;

import Mobil.app.service.FCMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class NotificationScheduler {

    @Autowired
    private FCMService fcmService;

    /**
     * Har kuni ertalab 8:00 da xodimga eslatma
     */
    @Scheduled(cron = "0 0 8 * * *")
    public void sendMorningReminder() {
        String title = "Yaxshi tong!";
        String body = "Bugungi vazifalaringizni ko'ring";

        Map<String, String> data = new HashMap<>();
        data.put("type", "REMINDER");

        fcmService.sendNotificationToTopic("role_cleaner", title, body, data);
    }

    /**
     * Har soatda zaxira tekshirish
     */
    @Scheduled(fixedRate = 3600000) // 1 soat
    public void checkInventory() {
        // Zaxira tekshirish va notification yuborish
    }
}
```

## 🧪 Test Qilish

### Postman Collection

```json
{
  "info": {
    "name": "FCM Notifications",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Send Test Notification",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"fcmToken\": \"YOUR_FCM_TOKEN\",\n  \"title\": \"Test\",\n  \"body\": \"Bu test\"\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "{{baseUrl}}/api/notifications/send-test",
          "host": ["{{baseUrl}}"],
          "path": ["api", "notifications", "send-test"]
        }
      }
    }
  ]
}
```

## 📝 Notes

1. **firebase-service-account.json** faylini `.gitignore` ga qo'shing
2. FCM token ni database da saqlang
3. Token null bo'lsa notification yubormaslik
4. Error handling qo'shing
5. Rate limiting qo'shing (spam oldini olish)
6. Logging qo'shing (monitoring uchun)

## 🔒 Security

```java
// FCM token ni faqat o'z tokenini yangilashi mumkin
@PostMapping("/fcm-token")
public ResponseEntity<?> saveFCMToken(
        @RequestBody Map<String, String> request,
        Authentication authentication) {
    
    // Current user ni olish
    String username = authentication.getName();
    
    // Faqat o'z tokenini yangilash
    User user = userRepository.findByUsername(username)
        .orElseThrow(() -> new RuntimeException("User not found"));
    
    user.setFcmToken(request.get("fcmToken"));
    userRepository.save(user);
    
    return ResponseEntity.ok().build();
}
```
