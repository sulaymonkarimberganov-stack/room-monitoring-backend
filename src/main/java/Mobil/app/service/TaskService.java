package Mobil.app.service;

import Mobil.app.dto.TaskDto;
import Mobil.app.entity.Room;
import Mobil.app.entity.Task;
import Mobil.app.entity.User;
import Mobil.app.repository.RoomRepository;
import Mobil.app.repository.TaskRepository;
import Mobil.app.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TaskService {

    private final TaskRepository taskRepository;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;

    public Task createTask(Long roomId, Long assignedToId, String assignedByUsername, String description) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Xona topilmadi"));

        User assignedTo = userRepository.findById(assignedToId)
                .orElseThrow(() -> new RuntimeException("Xodim topilmadi"));

        User assignedBy = userRepository.findByUsername(assignedByUsername)
                .orElseThrow(() -> new RuntimeException("Foydalanuvchi topilmadi"));

        Task task = Task.builder()
                .room(room)
                .assignedTo(assignedTo)
                .assignedBy(assignedBy)
                .description(description)
                .status(Task.TaskStatus.PENDING)
                .build();

        return taskRepository.save(task);
    }

    public Task updateTaskStatus(Long taskId, Task.TaskStatus status, String username) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Vazifa topilmadi"));

        task.setStatus(status);

        if (status == Task.TaskStatus.DONE) {
            task.setCompletedAt(LocalDateTime.now());
            // Xona statusini ham yangilaymiz
            task.getRoom().setStatus(Room.RoomStatus.CLEAN);
            task.getRoom().setLastCleanedAt(LocalDateTime.now());
            userRepository.findByUsername(username)
                    .ifPresent(task.getRoom()::setLastCleanedBy);
            roomRepository.save(task.getRoom());
        } else if (status == Task.TaskStatus.IN_PROGRESS) {
            task.getRoom().setStatus(Room.RoomStatus.IN_PROGRESS);
            roomRepository.save(task.getRoom());
        }

        return taskRepository.save(task);
    }

    public List<Task> getMyTasks(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Foydalanuvchi topilmadi"));
        return taskRepository.findByAssignedTo(user);
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public TaskDto toDto(Task task) {
        TaskDto dto = new TaskDto();
        dto.setId(task.getId());
        dto.setRoomId(task.getRoom().getId());
        dto.setRoomNumber(task.getRoom().getRoomNumber());
        dto.setAssignedToId(task.getAssignedTo().getId());
        dto.setAssignedToName(task.getAssignedTo().getFullName());
        dto.setDescription(task.getDescription());
        dto.setStatus(task.getStatus());
        dto.setCreatedAt(task.getCreatedAt());
        dto.setCompletedAt(task.getCompletedAt());
        return dto;
    }
}
