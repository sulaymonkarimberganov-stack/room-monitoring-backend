package Mobil.app.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "rooms")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String roomNumber;

    @Column
    private String floor;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RoomStatus status;

    @Column
    private LocalDateTime lastCleanedAt;

    @ManyToOne
    @JoinColumn(name = "last_cleaned_by")
    private User lastCleanedBy;

    public enum RoomStatus {
        CLEAN,        // Toza
        DIRTY,        // Tozalanmagan
        IN_PROGRESS   // Jarayonda
    }
}
