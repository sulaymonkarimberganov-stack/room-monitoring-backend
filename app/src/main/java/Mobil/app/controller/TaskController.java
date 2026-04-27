package Mobil.app.controller;

import Mobil.app.entity.Task;
import Mobil.app.entity.User;
import Mobil.app.repository.TaskRepository;
import Mobil.app.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    private final TaskRepository taskRepository;
    private final UserRepository userRepository;

    public TaskController(TaskRepository taskRepository, UserRepository userRepository) {
        this.taskRepository = taskRepository;
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    @GetMapping("/my")
    public ResponseEntity<List<Task>> getMyTasks(Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));
        return ResponseEntity.ok(taskRepository.findByAssignedTo(user));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Task> updateTaskStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        return taskRepository.findById(id)
                .map(task -> {
                    task.setStatus(Task.TaskStatus.valueOf(body.get("status")));
                    if (task.getStatus() == Task.TaskStatus.COMPLETED) {
                        task.setCompletedAt(LocalDateTime.now());
                    }
                    return ResponseEntity.ok(taskRepository.save(task));
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
