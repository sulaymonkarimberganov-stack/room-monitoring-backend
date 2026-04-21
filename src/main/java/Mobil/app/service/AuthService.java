package Mobil.app.service;

import Mobil.app.dto.AuthRequest;
import Mobil.app.dto.AuthResponse;
import Mobil.app.entity.User;
import Mobil.app.repository.UserRepository;
import Mobil.app.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthResponse login(AuthRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException("Foydalanuvchi topilmadi"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Parol noto'g'ri");
        }

        String token = jwtUtil.generateToken(user.getUsername(), user.getRole().name());
        return new AuthResponse(token, user.getUsername(), user.getRole().name());
    }

    public User register(String username, String password, String fullName, User.Role role) {
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Bu username allaqachon mavjud");
        }

        User user = User.builder()
                .username(username)
                .password(passwordEncoder.encode(password))
                .fullName(fullName)
                .role(role)
                .build();

        return userRepository.save(user);
    }
}
