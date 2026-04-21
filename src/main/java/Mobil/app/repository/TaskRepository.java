package Mobil.app.repository;

import Mobil.app.entity.Task;
import Mobil.app.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByAssignedTo(User user);
    List<Task> findByRoomId(Long roomId);
    List<Task> findByStatus(Task.TaskStatus status);
    List<Task> findByAssignedToAndStatus(User user, Task.TaskStatus status);
}
