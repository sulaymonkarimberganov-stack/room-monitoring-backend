package Mobil.app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "floors")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Floor {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private Integer floorNumber; // -3 to 8
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ZoneType zoneType;
    
    @Column(nullable = false)
    private String displayName; // e.g., "Parking Level -3", "Office Floor 2", "Hotel Floor 5"
    
    private Integer totalRooms; // Total monitoring points on this floor
    
    private Integer cleanRooms; // Clean rooms count
    
    private Integer dirtyRooms; // Dirty rooms count
    
    public enum ZoneType {
        PARKING,  // Floors -3 to -1
        OFFICE,   // Floors 1 to 3
        HOTEL     // Floors 4 to 8
    }
    
    // Helper method to get zone color
    public String getZoneColor() {
        return switch (zoneType) {
            case PARKING -> "#607D8B"; // Gray-Blue
            case OFFICE -> "#FFC107";  // Yellow
            case HOTEL -> "#4CAF50";   // Green
        };
    }
    
    // Helper method to calculate cleanliness percentage
    public double getCleanlinessPercentage() {
        if (totalRooms == null || totalRooms == 0) return 0.0;
        if (cleanRooms == null) return 0.0;
        return (cleanRooms * 100.0) / totalRooms;
    }
}
