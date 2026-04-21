package Mobil.app.repository;

import Mobil.app.entity.RoomItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RoomItemRepository extends JpaRepository<RoomItem, Long> {
    List<RoomItem> findByRoomId(Long roomId);

    // Miqdori kam bo'lgan buyumlar (signal uchun)
    @Query("SELECT ri FROM RoomItem ri WHERE ri.quantity <= ri.minQuantity")
    List<RoomItem> findLowStockItems();
}
