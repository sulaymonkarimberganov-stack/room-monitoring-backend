package Mobil.app.controller;

import Mobil.app.entity.Room;
import Mobil.app.entity.Task;
import Mobil.app.entity.User;
import Mobil.app.repository.RoomRepository;
import Mobil.app.repository.TaskRepository;
import Mobil.app.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/manager")
public class ManagerController {

    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final TaskRepository taskRepository;

    public ManagerController(UserRepository userRepository, RoomRepository roomRepository, TaskRepository taskRepository) {
        this.userRepository = userRepository;
        this.roomRepository = roomRepository;
        this.taskRepository = taskRepository;
    }

    @GetMapping("/overview")
    public ResponseEntity<Map<String, Object>> getOverview() {
        // Get all staff members
        List<User> staffList = userRepository.findByRole(User.Role.STAFF);

        // Get all rooms
        List<Room> allRooms = roomRepository.findAll();

        // Calculate summary
        Map<String, Integer> summary = new HashMap<>();
        summary.put("total", allRooms.size());
        summary.put("clean", (int) allRooms.stream().filter(r -> r.getStatus() == Room.RoomStatus.CLEAN).count());
        summary.put("dirty", (int) allRooms.stream().filter(r -> r.getStatus() == Room.RoomStatus.DIRTY).count());
        summary.put("occupied", (int) allRooms.stream().filter(r -> r.getStatus() == Room.RoomStatus.OCCUPIED).count());

        // Build staff data with their rooms
        List<Map<String, Object>> staffData = staffList.stream().map(staff -> {
            Map<String, Object> staffMap = new HashMap<>();
            staffMap.put("staffId", staff.getId());
            staffMap.put("staffName", staff.getFullName());
            staffMap.put("avatar", staff.getAvatar());
            staffMap.put("avatarColor", staff.getAvatarColor());

            // Get rooms assigned to this staff
            List<Room> assignedRooms = roomRepository.findByAssignedStaff(staff);

            List<Map<String, Object>> roomsData = assignedRooms.stream().map(room -> {
                Map<String, Object> roomMap = new HashMap<>();
                roomMap.put("roomId", room.getId());
                roomMap.put("roomNumber", room.getRoomNumber());
                roomMap.put("status", room.getStatus().toString());
                
                // Format last cleaned time
                if (room.getLastCleaned() != null) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");
                    roomMap.put("lastCleaned", room.getLastCleaned().format(formatter));
                } else {
                    roomMap.put("lastCleaned", null);
                }

                // Check if room has photos
                List<Task> tasksWithPhotos = taskRepository.findByRoom(room).stream()
                        .filter(task -> task.getPhotoUrl() != null && !task.getPhotoUrl().isEmpty())
                        .filter(task -> task.getStatus() == Task.TaskStatus.COMPLETED)
                        .collect(Collectors.toList());
                
                roomMap.put("hasPhoto", !tasksWithPhotos.isEmpty());
                roomMap.put("photoCount", tasksWithPhotos.size());

                return roomMap;
            }).collect(Collectors.toList());

            staffMap.put("rooms", roomsData);
            staffMap.put("roomCount", roomsData.size());

            return staffMap;
        }).collect(Collectors.toList());

        // Build response
        Map<String, Object> response = new HashMap<>();
        response.put("summary", summary);
        response.put("staff", staffData);

        return ResponseEntity.ok(response);
    }
}
