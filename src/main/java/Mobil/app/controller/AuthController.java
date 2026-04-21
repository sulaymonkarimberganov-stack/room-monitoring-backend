package Mobil.app.controller;

import Mobil.app.dto.AuthRequest;
import Mobil.app.dto.AuthResponse;
import Mobil.app.entity.User;
import Mobil.app.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "1. Auth", description = "Login va ro'yxatdan o'tish")
public class AuthController {

    private final AuthService authService;

    @Operation(summary = "Login", description = "Username va parol bilan kirish. Token qaytaradi.")
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody AuthRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @Operation(summary = "Yangi foydalanuvchi qo'shish", description = "Role: ADMIN, MANAGER, CLEANER")
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        User user = authService.register(
                request.getUsername(),
                request.getPassword(),
                request.getFullName(),
                User.Role.valueOf(request.getRole())
        );
        return ResponseEntity.ok("Foydalanuvchi yaratildi: " + user.getUsername());
    }

    @Data
    static class RegisterRequest {
        private String username;
        private String password;
        private String fullName;
        private String role;
    }
}
