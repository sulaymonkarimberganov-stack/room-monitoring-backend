package Mobil.app.repository;

import Mobil.app.entity.Floor;
import Mobil.app.entity.Room;
import Mobil.app.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    Optional<Room> findByRoomNumber(String roomNumber);
    List<Room> findByStatus(Room.RoomStatus status);
    List<Room> findByFloor(Floor floor);
    List<Room> findByAssignedStaff(User assignedStaff);
    long countByFloor(Floor floor);
    long countByFloorAndStatus(Floor floor, Room.RoomStatus status);
}
