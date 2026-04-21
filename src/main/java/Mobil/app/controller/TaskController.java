package Mobil.app.controller;

import Mobil.app.dto.TaskDto;
import Mobil.app.entity.Task;
import Mobil.app.service.TaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
@RequiredArgsConstructor
@Tag(name = "3. Tasks", description = "Vazifalar boshqaruvi")
public class TaskController {

    private final TaskService taskService;

    @Operation(summary = "Barcha vazifalar", description = "Faqat ADMIN va MANAGER")
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<TaskDto>> getAllTasks() {
        List<TaskDto> tasks = taskService.getAllTasks()
                .stream().map(taskService::toDto).toList();
        return ResponseEntity.ok(tasks);
    }

    @Operation(summary = "Mening vazifalarim", description = "Login qilgan xodimning vazifalari")
    @GetMapping("/my")
    public ResponseEntity<List<TaskDto>> getMyTasks(Authentication auth) {
        List<TaskDto> tasks = taskService.getMyTasks(auth.getName())
                .stream().map(taskService::toDto).toList();
        return ResponseEntity.ok(tasks);
    }

    @Operation(summary = "Yangi vazifa berish", description = "Faqat ADMIN va MANAGER")
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<TaskDto> createTask(
            @RequestBody CreateTaskRequest request,
            Authentication auth) {
        Task task = taskService.createTask(
                request.roomId(),
                request.assignedToId(),
                auth.getName(),
                request.description()
        );
        return ResponseEntity.ok(taskService.toDto(task));
    }

    @Operation(summary = "Vazifa statusini yangilash", description = "Status: PENDING, IN_PROGRESS, DONE")
    @PatchMapping("/{id}/status")
    public ResponseEntity<TaskDto> updateStatus(
            @PathVariable Long id,
            @RequestBody UpdateStatusRequest request,
            Authentication auth) {
        Task task = taskService.updateTaskStatus(id, Task.TaskStatus.valueOf(request.status()), auth.getName());
        return ResponseEntity.ok(taskService.toDto(task));
    }

    record CreateTaskRequest(Long roomId, Long assignedToId, String description) {}
    record UpdateStatusRequest(String status) {}
}
