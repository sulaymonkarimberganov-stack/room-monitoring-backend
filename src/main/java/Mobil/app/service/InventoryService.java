package Mobil.app.service;

import Mobil.app.entity.Item;
import Mobil.app.entity.Room;
import Mobil.app.entity.RoomItem;
import Mobil.app.repository.ItemRepository;
import Mobil.app.repository.RoomItemRepository;
import Mobil.app.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InventoryService {

    private final RoomItemRepository roomItemRepository;
    private final RoomRepository roomRepository;
    private final ItemRepository itemRepository;

    public List<RoomItem> getRoomInventory(Long roomId) {
        return roomItemRepository.findByRoomId(roomId);
    }

    public List<RoomItem> getLowStockItems() {
        return roomItemRepository.findLowStockItems();
    }

    public RoomItem updateQuantity(Long roomItemId, int quantity) {
        RoomItem roomItem = roomItemRepository.findById(roomItemId)
                .orElseThrow(() -> new RuntimeException("Buyum topilmadi"));
        roomItem.setQuantity(quantity);
        return roomItemRepository.save(roomItem);
    }

    public RoomItem addItemToRoom(Long roomId, Long itemId, int quantity, int minQuantity) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Xona topilmadi"));
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Buyum topilmadi"));

        RoomItem roomItem = RoomItem.builder()
                .room(room)
                .item(item)
                .quantity(quantity)
                .minQuantity(minQuantity)
                .build();

        return roomItemRepository.save(roomItem);
    }

    public Item createItem(String name, String description) {
        Item item = Item.builder()
                .name(name)
                .description(description)
                .build();
        return itemRepository.save(item);
    }

    public List<Item> getAllItems() {
        return itemRepository.findAll();
    }
}
