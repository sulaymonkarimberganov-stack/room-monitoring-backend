package Mobil.app.service;

import Mobil.app.dto.RoomDto;
import Mobil.app.entity.Room;
import Mobil.app.entity.User;
import Mobil.app.repository.RoomRepository;
import Mobil.app.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RoomService {

    private final RoomRepository roomRepository;
    private final UserRepository userRepository;

    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    public List<Room> getRoomsByStatus(Room.RoomStatus status) {
        return roomRepository.findByStatus(status);
    }

    public Room getRoomById(Long id) {
        return roomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Xona topilmadi: " + id));
    }

    public Room createRoom(String roomNumber, String floor) {
        Room room = Room.builder()
                .roomNumber(roomNumber)
                .floor(floor)
                .status(Room.RoomStatus.DIRTY)
                .build();
        return roomRepository.save(room);
    }

    public Room updateStatus(Long roomId, Room.RoomStatus status, String cleanerUsername) {
        Room room = getRoomById(roomId);
        room.setStatus(status);

        if (status == Room.RoomStatus.CLEAN) {
            room.setLastCleanedAt(LocalDateTime.now());
            userRepository.findByUsername(cleanerUsername)
                    .ifPresent(room::setLastCleanedBy);
        }

        return roomRepository.save(room);
    }

    public RoomDto toDto(Room room) {
        RoomDto dto = new RoomDto();
        dto.setId(room.getId());
        dto.setRoomNumber(room.getRoomNumber());
        dto.setFloor(room.getFloor());
        dto.setStatus(room.getStatus());
        dto.setLastCleanedAt(room.getLastCleanedAt());
        if (room.getLastCleanedBy() != null) {
            dto.setLastCleanedBy(room.getLastCleanedBy().getFullName());
        }
        return dto;
    }
}
