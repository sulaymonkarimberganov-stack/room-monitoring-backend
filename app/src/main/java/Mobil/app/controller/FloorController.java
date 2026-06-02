package Mobil.app.controller;

import Mobil.app.entity.Floor;
import Mobil.app.repository.FloorRepository;
import Mobil.app.repository.RoomRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/floors")
public class FloorController {

    private final FloorRepository floorRepository;
    private final RoomRepository roomRepository;

    public FloorController(FloorRepository floorRepository, RoomRepository roomRepository) {
        this.floorRepository = floorRepository;
        this.roomRepository = roomRepository;
    }

    @GetMapping
    public ResponseEntity<List<Floor>> getAllFloors() {
        List<Floor> floors = floorRepository.findAllByOrderByFloorNumberAsc();
        
        // Update room counts for each floor
        floors.forEach(floor -> {
            long total = roomRepository.countByFloor(floor);
            long clean = roomRepository.countByFloorAndStatus(floor, Mobil.app.entity.Room.RoomStatus.CLEAN);
            long dirty = roomRepository.countByFloorAndStatus(floor, Mobil.app.entity.Room.RoomStatus.DIRTY);
            
            floor.setTotalRooms((int) total);
            floor.setCleanRooms((int) clean);
            floor.setDirtyRooms((int) dirty);
        });
        
        return ResponseEntity.ok(floors);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Floor> getFloorById(@PathVariable Long id) {
        return floorRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/number/{floorNumber}")
    public ResponseEntity<Floor> getFloorByNumber(@PathVariable Integer floorNumber) {
        return floorRepository.findByFloorNumber(floorNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/zone/{zoneType}")
    public ResponseEntity<List<Floor>> getFloorsByZone(@PathVariable Floor.ZoneType zoneType) {
        return ResponseEntity.ok(floorRepository.findByZoneType(zoneType));
    }

    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getBuildingStatistics() {
        List<Floor> floors = floorRepository.findAll();
        
        int totalFloors = floors.size();
        int totalRooms = floors.stream().mapToInt(f -> f.getTotalRooms() != null ? f.getTotalRooms() : 0).sum();
        int cleanRooms = floors.stream().mapToInt(f -> f.getCleanRooms() != null ? f.getCleanRooms() : 0).sum();
        int dirtyRooms = floors.stream().mapToInt(f -> f.getDirtyRooms() != null ? f.getDirtyRooms() : 0).sum();
        
        double avgCleanliness = floors.stream()
                .mapToDouble(Floor::getCleanlinessPercentage)
                .average()
                .orElse(0.0);
        
        return ResponseEntity.ok(Map.of(
                "totalFloors", totalFloors,
                "totalRooms", totalRooms,
                "cleanRooms", cleanRooms,
                "dirtyRooms", dirtyRooms,
                "averageCleanliness", Math.round(avgCleanliness * 100.0) / 100.0
        ));
    }
}
