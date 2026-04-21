package Mobil.app.repository;

import Mobil.app.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room, Long> {
    Optional<Room> findByRoomNumber(String roomNumber);
    List<Room> findByStatus(Room.RoomStatus status);
    List<Room> findByFloor(String floor);
}
