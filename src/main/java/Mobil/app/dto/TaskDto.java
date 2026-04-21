package Mobil.app.dto;

import Mobil.app.entity.Task;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TaskDto {
    private Long id;
    private Long roomId;
    private String roomNumber;
    private Long assignedToId;
    private String assignedToName;
    private String description;
    private Task.TaskStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;
}
