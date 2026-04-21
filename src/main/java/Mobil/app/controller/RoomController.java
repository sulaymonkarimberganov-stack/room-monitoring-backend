package Mobil.app.controller;

import Mobil.app.dto.RoomDto;
import Mobil.app.entity.Room;
import Mobil.app.service.RoomService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
@RequiredArgsConstructor
@Tag(name = "2. Rooms", description = "Xonalar monitoring")
public class RoomController {

    private final RoomService roomService;

    @Operation(summary = "Barcha xonalar", description = "Barcha xonalar ro'yxati va holati")
    @GetMapping
    public ResponseEntity<List<RoomDto>> getAllRooms() {
        List<RoomDto> rooms = roomService.getAllRooms()
                .stream().map(roomService::toDto).toList();
        return ResponseEntity.ok(rooms);
    }

    @Operation(summary = "Status bo'yicha filter", description = "Status: CLEAN, DIRTY, IN_PROGRESS")
    @GetMapping("/status/{status}")
    public ResponseEntity<List<RoomDto>> getRoomsByStatus(@PathVariable String status) {
        List<RoomDto> rooms = roomService.getRoomsByStatus(Room.RoomStatus.valueOf(status))
                .stream().map(roomService::toDto).toList();
        return ResponseEntity.ok(rooms);
    }

    @Operation(summary = "Bitta xona")
    @GetMapping("/{id}")
    public ResponseEntity<RoomDto> getRoom(@PathVariable Long id) {
        return ResponseEntity.ok(roomService.toDto(roomService.getRoomById(id)));
    }

    @Operation(summary = "Yangi xona qo'shish", description = "Faqat ADMIN")
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<RoomDto> createRoom(@RequestBody CreateRoomRequest request) {
        Room room = roomService.createRoom(request.roomNumber(), request.floor());
        return ResponseEntity.ok(roomService.toDto(room));
    }

    @Operation(summary = "Xona statusini yangilash", description = "Status: CLEAN, DIRTY, IN_PROGRESS")
    @PatchMapping("/{id}/status")
    public ResponseEntity<RoomDto> updateStatus(
            @PathVariable Long id,
            @RequestBody UpdateStatusRequest request,
            Authentication auth) {
        Room room = roomService.updateStatus(id, Room.RoomStatus.valueOf(request.status()), auth.getName());
        return ResponseEntity.ok(roomService.toDto(room));
    }

    record CreateRoomRequest(String roomNumber, String floor) {}
    record UpdateStatusRequest(String status) {}
}
