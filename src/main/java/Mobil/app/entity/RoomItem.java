package Mobil.app.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "room_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @ManyToOne
    @JoinColumn(name = "item_id", nullable = false)
    private Item item;

    @Column(nullable = false)
    private Integer quantity;

    @Column(nullable = false)
    private Integer minQuantity; // minimum miqdor — kamaysa signal beradi

    public boolean isLow() {
        return quantity <= minQuantity;
    }
}
