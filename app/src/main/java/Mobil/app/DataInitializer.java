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

            // Create 4 staff members
            User staff1 = new User();
            staff1.setUsername("aziz_cleaner");
            staff1.setPassword(passwordEncoder.encode("aziz123"));
            staff1.setFullName("Aziz Karimov");
            staff1.setRole(User.Role.STAFF);
            staff1.setCleaningCoins(150);
            staff1.setTasksCompleted(12);
            staff1.setAvatar("AK");
            staff1.setAvatarColor("#1565C0");
            userRepository.save(staff1);

            User staff2 = new User();
            staff2.setUsername("malika_cleaner");
            staff2.setPassword(passwordEncoder.encode("malika123"));
            staff2.setFullName("Malika Rahimova");
            staff2.setRole(User.Role.STAFF);
            staff2.setCleaningCoins(180);
            staff2.setTasksCompleted(15);
            staff2.setAvatar("MR");
            staff2.setAvatarColor("#5E35B1");
            userRepository.save(staff2);

            User staff3 = new User();
            staff3.setUsername("jasur_cleaner");
            staff3.setPassword(passwordEncoder.encode("jasur123"));
            staff3.setFullName("Jasur Toshmatov");
            staff3.setRole(User.Role.STAFF);
            staff3.setCleaningCoins(120);
            staff3.setTasksCompleted(10);
            staff3.setAvatar("JT");
            staff3.setAvatarColor("#2E7D32");
            userRepository.save(staff3);

            User staff4 = new User();
            staff4.setUsername("dilnoza_cleaner");
            staff4.setPassword(passwordEncoder.encode("dilnoza123"));
            staff4.setFullName("Dilnoza Yusupova");
            staff4.setRole(User.Role.STAFF);
            staff4.setCleaningCoins(200);
            staff4.setTasksCompleted(18);
            staff4.setAvatar("DY");
            staff4.setAvatarColor("#C62828");
            userRepository.save(staff4);

            System.out.println("✅ Default users created:");
            System.out.println("   Admin: admin / admin123");
            System.out.println("   Manager: manager / manager123");
            System.out.println("   Staff 1: aziz_cleaner / aziz123");
            System.out.println("   Staff 2: malika_cleaner / malika123");
            System.out.println("   Staff 3: jasur_cleaner / jasur123");
            System.out.println("   Staff 4: dilnoza_cleaner / dilnoza123");
        }

        // Create 12 rooms with assigned staff
        if (roomRepository.count() == 0) {
            User staff1 = userRepository.findByUsername("aziz_cleaner").orElse(null);
            User staff2 = userRepository.findByUsername("malika_cleaner").orElse(null);
            User staff3 = userRepository.findByUsername("jasur_cleaner").orElse(null);
            User staff4 = userRepository.findByUsername("dilnoza_cleaner").orElse(null);

            // Rooms 1-3 assigned to Aziz
            for (int i = 1; i <= 3; i++) {
                Room room = new Room();
                room.setRoomNumber(String.valueOf(i));
                room.setType(Room.RoomType.DOUBLE);
                room.setStatus(i % 2 == 0 ? Room.RoomStatus.DIRTY : Room.RoomStatus.CLEAN);
                room.setAssignedStaff(staff1);
                roomRepository.save(room);
            }

            // Rooms 4-6 assigned to Malika
            for (int i = 4; i <= 6; i++) {
                Room room = new Room();
                room.setRoomNumber(String.valueOf(i));
                room.setType(i == 6 ? Room.RoomType.SUITE : Room.RoomType.DOUBLE);
                room.setStatus(i % 2 == 0 ? Room.RoomStatus.CLEAN : Room.RoomStatus.DIRTY);
                room.setAssignedStaff(staff2);
                roomRepository.save(room);
            }

            // Rooms 7-9 assigned to Jasur
            for (int i = 7; i <= 9; i++) {
                Room room = new Room();
                room.setRoomNumber(String.valueOf(i));
                room.setType(i == 9 ? Room.RoomType.SUITE : Room.RoomType.DOUBLE);
                room.setStatus(i % 2 == 0 ? Room.RoomStatus.DIRTY : Room.RoomStatus.CLEAN);
                room.setAssignedStaff(staff3);
                roomRepository.save(room);
            }

            // Rooms 10-12 assigned to Dilnoza
            for (int i = 10; i <= 12; i++) {
                Room room = new Room();
                room.setRoomNumber(String.valueOf(i));
                room.setType(i == 12 ? Room.RoomType.SUITE : Room.RoomType.DOUBLE);
                room.setStatus(i % 2 == 0 ? Room.RoomStatus.CLEAN : Room.RoomStatus.DIRTY);
                room.setAssignedStaff(staff4);
                roomRepository.save(room);
            }

            System.out.println("✅ 12 rooms created with staff assignments:");
            System.out.println("   Rooms 1-3 → Aziz Karimov");
            System.out.println("   Rooms 4-6 → Malika Rahimova");
            System.out.println("   Rooms 7-9 → Jasur Toshmatov");
            System.out.println("   Rooms 10-12 → Dilnoza Yusupova");
        }

        // Create sample inventory items (O'zbek tilida)
        if (inventoryRepository.count() == 0) {
            inventoryRepository.save(new InventoryItem(null, "Sochiq", 50, 20, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Choyshab", 30, 15, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Sovun", 100, 30, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Shampun", 80, 25, "shisha", null));
            inventoryRepository.save(new InventoryItem(null, "Tualet qog'ozi", 150, 50, "rulon", null));
            inventoryRepository.save(new InventoryItem(null, "Yostiq", 40, 15, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Ko'rpa", 35, 12, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Tozalash spreyi", 25, 10, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Axlat qoplari", 200, 50, "dona", null));
            inventoryRepository.save(new InventoryItem(null, "Shippak", 60, 20, "juft", null));
            System.out.println("✅ Sample inventory items created (O'zbek tilida)");
        }

        // Create sample tasks
        if (taskRepository.count() == 0) {
            User staff = userRepository.findByUsername("aziz_cleaner").orElse(null);
            Room room = roomRepository.findByRoomNumber("1").orElse(null);
            
            if (staff != null && room != null) {
                Task task = new Task();
                task.setTitle("Clean Room 1");
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
