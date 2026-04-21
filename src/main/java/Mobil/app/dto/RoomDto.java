package Mobil.app.dto;

import Mobil.app.entity.Room;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RoomDto {
    private Long id;
    private String roomNumber;
    private String floor;
    private Room.RoomStatus status;
    private LocalDateTime lastCleanedAt;
    private String lastCleanedBy;
}
