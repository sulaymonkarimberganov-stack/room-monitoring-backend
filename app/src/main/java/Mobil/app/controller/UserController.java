package Mobil.app.controller;

import Mobil.app.entity.Room;
import Mobil.app.entity.User;
import Mobil.app.repository.RoomRepository;
import Mobil.app.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;
    private final RoomRepository roomRepository;

    public UserController(UserRepository userRepository, RoomRepository roomRepository) {
        this.userRepository = userRepository;
        this.roomRepository = roomRepository;
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getUsers(@RequestParam(required = false) String role) {
        List<User> users;
        
        if (role != null && role.equalsIgnoreCase("STAFF")) {
            users = userRepository.findByRole(User.Role.STAFF);
        } else if (role != null && role.equalsIgnoreCase("CLEANER")) {
            // CLEANER is same as STAFF
            users = userRepository.findByRole(User.Role.STAFF);
        } else {
            users = userRepository.findAll();
        }

        List<Map<String, Object>> response = users.stream().map(user -> {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("username", user.getUsername());
            userMap.put("fullName", user.getFullName());
            userMap.put("role", user.getRole().toString());
            userMap.put("cleaningCoins", user.getCleaningCoins());
            userMap.put("tasksCompleted", user.getTasksCompleted());
            userMap.put("avatar", user.getAvatar());
            userMap.put("avatarColor", user.getAvatarColor());
            userMap.put("createdAt", user.getCreatedAt());
            
            // Get assigned rooms
            List<Room> assignedRooms = roomRepository.findByAssignedStaff(user);
            List<String> roomNumbers = assignedRooms.stream()
                    .map(Room::getRoomNumber)
                    .collect(Collectors.toList());
            userMap.put("assignedRooms", roomNumbers);
            
            return userMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}/rooms")
    public ResponseEntity<List<Map<String, Object>>> getUserRooms(@PathVariable Long id) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        List<Room> rooms = roomRepository.findByAssignedStaff(user);
        List<Map<String, Object>> response = rooms.stream().map(room -> {
            Map<String, Object> roomMap = new HashMap<>();
            roomMap.put("id", room.getId());
            roomMap.put("roomNumber", room.getRoomNumber());
            roomMap.put("type", room.getType().toString());
            roomMap.put("status", room.getStatus().toString());
            return roomMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }
}
