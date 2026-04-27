package Mobil.app;

import Mobil.app.entity.InventoryItem;
import Mobil.app.entity.Room;
import Mobil.app.entity.Task;
import Mobil.app.entity.User;
import Mobil.app.repository.InventoryRepository;
import Mobil.app.repository.RoomRepository;
import Mobil.app.repository.TaskRepository;
import Mobil.app.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final TaskRepository taskRepository;
    private final InventoryRepository inventoryRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserRepository userRepository, RoomRepository roomRepository,
                          TaskRepository taskRepository, InventoryRepository inventoryRepository,
                          PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roomRepository = roomRepository;
        this.taskRepository = taskRepository;
        this.inventoryRepository = inventoryRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        // Create default users if not exist
        if (userRepository.count() == 0) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setFullName("Administrator");
            admin.setRole(User.Role.ADMIN);
            userRepository.save(admin);

            User manager = new User();
            manager.setUsername("manager");
            manager.setPassword(passwordEncoder.encode("manager123"));
            manager.setFullName("Manager User");
            manager.setRole(User.Role.MANAGER);
            userRepository.save(manager);

            User staff = new User();
            staff.setUsername("staff");
            staff.setPassword(passwordEncoder.encode("staff123"));
            staff.setFullName("Staff User");
            staff.setRole(User.Role.STAFF);
            userRepository.save(staff);

            System.out.println("✅ Default users created:");
            System.out.println("   Admin: admin / admin123");
            System.out.println("   Manager: manager / manager123");
            System.out.println("   Staff: staff / staff123");
        }

        // Create sample rooms
        if (roomRepository.count() == 0) {
            for (int i = 1; i <= 10; i++) {
                Room room = new Room();
                room.setRoomNumber("10" + i);
                room.setType(i % 4 == 0 ? Room.RoomType.SUITE : Room.RoomType.DOUBLE);
                room.setStatus(i % 3 == 0 ? Room.RoomStatus.DIRTY : Room.RoomStatus.CLEAN);
                roomRepository.save(room);
            }
            System.out.println("✅ Sample rooms created");
        }

        // Create sample inventory items
        if (inventoryRepository.count() == 0) {
            inventoryRepository.save(new InventoryItem(null, "Towels", 50, 20, "pcs", null));
            inventoryRepository.save(new InventoryItem(null, "Bed Sheets", 30, 15, "pcs", null));
            inventoryRepository.save(new InventoryItem(null, "Soap", 100, 30, "pcs", null));
            inventoryRepository.save(new InventoryItem(null, "Shampoo", 80, 25, "bottles", null));
            inventoryRepository.save(new InventoryItem(null, "Toilet Paper", 15, 20, "rolls", null));
            System.out.println("✅ Sample inventory items created");
        }

        // Create sample tasks
        if (taskRepository.count() == 0) {
            User staff = userRepository.findByUsername("staff").orElse(null);
            Room room = roomRepository.findByRoomNumber("101").orElse(null);
            
            if (staff != null && room != null) {
                Task task = new Task();
                task.setTitle("Clean Room 101");
                task.setDescription("Deep cleaning required");
                task.setRoom(room);
                task.setAssignedTo(staff);
                task.setStatus(Task.TaskStatus.PENDING);
                task.setPriority(Task.TaskPriority.HIGH);
                taskRepository.save(task);
                System.out.println("✅ Sample task created");
            }
        }
    }
}
