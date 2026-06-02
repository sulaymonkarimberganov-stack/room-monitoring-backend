package Mobil.app.controller;

import Mobil.app.entity.Room;
import Mobil.app.entity.Task;
import Mobil.app.repository.RoomRepository;
import Mobil.app.repository.TaskRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    private final RoomRepository roomRepository;
    private final TaskRepository taskRepository;

    public RoomController(RoomRepository roomRepository, TaskRepository taskRepository) {
        this.roomRepository = roomRepository;
        this.taskRepository = taskRepository;
    }

    @GetMapping
    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Room> getRoomById(@PathVariable Long id) {
        return roomRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Room> updateRoomStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        return roomRepository.findById(id)
                .map(room -> {
                    room.setStatus(Room.RoomStatus.valueOf(body.get("status")));
                    if (room.getStatus() == Room.RoomStatus.CLEAN) {
                        room.setLastCleaned(LocalDateTime.now());
                    }
                    return ResponseEntity.ok(roomRepository.save(room));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/photos")
    public ResponseEntity<List<Map<String, Object>>> getRoomPhotos(@PathVariable Long id) {
        Room room = roomRepository.findById(id).orElse(null);
        if (room == null) {
            return ResponseEntity.notFound().build();
        }

        // Get all completed tasks for this room that have photos
        List<Task> tasksWithPhotos = taskRepository.findByRoom(room).stream()
                .filter(task -> task.getPhotoUrl() != null && !task.getPhotoUrl().isEmpty())
                .filter(task -> task.getStatus() == Task.TaskStatus.COMPLETED)
                .sorted(Comparator.comparing(Task::getCompletedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .collect(Collectors.toList());

        List<Map<String, Object>> photos = tasksWithPhotos.stream().map(task -> {
            Map<String, Object> photo = new HashMap<>();
            photo.put("url", task.getPhotoUrl());
            photo.put("taskId", task.getId());
            photo.put("staffId", task.getAssignedTo() != null ? task.getAssignedTo().getId() : null);
            photo.put("staffName", task.getAssignedTo() != null ? task.getAssignedTo().getFullName() : "Noma'lum");
            
            if (task.getCompletedAt() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");
                photo.put("uploadedAt", task.getCompletedAt().format(formatter));
            } else {
                photo.put("uploadedAt", "Noma'lum");
            }
            
            return photo;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(photos);
    }
}
