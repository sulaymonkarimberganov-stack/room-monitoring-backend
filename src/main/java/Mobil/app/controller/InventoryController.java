package Mobil.app.controller;

import Mobil.app.entity.Item;
import Mobil.app.entity.RoomItem;
import Mobil.app.service.InventoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/inventory")
@RequiredArgsConstructor
@Tag(name = "4. Inventory", description = "Xizmat buyumlari nazorati")
public class InventoryController {

    private final InventoryService inventoryService;

    @Operation(summary = "Barcha buyum turlari")
    @GetMapping("/items")
    public ResponseEntity<List<Item>> getAllItems() {
        return ResponseEntity.ok(inventoryService.getAllItems());
    }

    @Operation(summary = "Yangi buyum turi qo'shish", description = "Faqat ADMIN. Masalan: sovun, sochiq, suv")
    @PostMapping("/items")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Item> createItem(@RequestBody CreateItemRequest request) {
        return ResponseEntity.ok(inventoryService.createItem(request.name(), request.description()));
    }

    @Operation(summary = "Xonadagi buyumlar ro'yxati")
    @GetMapping("/rooms/{roomId}")
    public ResponseEntity<List<RoomItem>> getRoomInventory(@PathVariable Long roomId) {
        return ResponseEntity.ok(inventoryService.getRoomInventory(roomId));
    }

    @Operation(summary = "Xonaga buyum qo'shish", description = "Faqat ADMIN va MANAGER")
    @PostMapping("/rooms/{roomId}/items")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<RoomItem> addItemToRoom(
            @PathVariable Long roomId,
            @RequestBody AddItemRequest request) {
        return ResponseEntity.ok(inventoryService.addItemToRoom(
                roomId, request.itemId(), request.quantity(), request.minQuantity()));
    }

    @Operation(summary = "Buyum miqdorini yangilash")
    @PatchMapping("/room-items/{id}")
    public ResponseEntity<RoomItem> updateQuantity(
            @PathVariable Long id,
            @RequestBody UpdateQuantityRequest request) {
        return ResponseEntity.ok(inventoryService.updateQuantity(id, request.quantity()));
    }

    @Operation(summary = "Kam qolgan buyumlar", description = "Miqdori minimum darajadan past buyumlar — signal uchun")
    @GetMapping("/low-stock")
    public ResponseEntity<List<RoomItem>> getLowStock() {
        return ResponseEntity.ok(inventoryService.getLowStockItems());
    }

    record CreateItemRequest(String name, String description) {}
    record AddItemRequest(Long itemId, int quantity, int minQuantity) {}
    record UpdateQuantityRequest(int quantity) {}
}
