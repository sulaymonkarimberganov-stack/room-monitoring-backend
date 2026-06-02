package Mobil.app.repository;

import Mobil.app.entity.Floor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FloorRepository extends JpaRepository<Floor, Long> {
    Optional<Floor> findByFloorNumber(Integer floorNumber);
    List<Floor> findAllByOrderByFloorNumberAsc();
    List<Floor> findByZoneType(Floor.ZoneType zoneType);
}
