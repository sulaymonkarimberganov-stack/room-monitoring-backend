package Mobil.app.controller;

import Mobil.app.entity.User;
import Mobil.app.repository.UserRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/leaderboard")
public class LeaderboardController {

    private final UserRepository userRepository;

    public LeaderboardController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getLeaderboard() {
        // Get top 10 users by cleaning coins
        List<User> topUsers = userRepository.findAll(
                PageRequest.of(0, 10, Sort.by(Sort.Direction.DESC, "cleaningCoins"))
        ).getContent();
        
        List<Map<String, Object>> leaderboard = topUsers.stream()
                .map(user -> {
                    Map<String, Object> entry = new HashMap<>();
                    entry.put("id", user.getId());
                    entry.put("username", user.getUsername());
                    entry.put("fullName", user.getFullName());
                    entry.put("cleaningCoins", user.getCleaningCoins());
                    entry.put("tasksCompleted", user.getTasksCompleted());
                    entry.put("role", user.getRole().toString());
                    return entry;
                })
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(leaderboard);
    }

    @GetMapping("/my-rank")
    public ResponseEntity<Map<String, Object>> getMyRank(@RequestHeader("Authorization") String token) {
        // This would need proper JWT parsing in production
        // For now, returning mock data
        Map<String, Object> rankInfo = new HashMap<>();
        rankInfo.put("rank", 1);
        rankInfo.put("totalUsers", userRepository.count());
        rankInfo.put("cleaningCoins", 0);
        rankInfo.put("tasksCompleted", 0);
        
        return ResponseEntity.ok(rankInfo);
    }

    @PostMapping("/award-coins")
    public ResponseEntity<Map<String, Object>> awardCoins(
            @RequestParam Long userId,
            @RequestParam Integer coins) {
        
        return userRepository.findById(userId)
                .map(user -> {
                    user.setCleaningCoins(user.getCleaningCoins() + coins);
                    user.setTasksCompleted(user.getTasksCompleted() + 1);
                    userRepository.save(user);
                    
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", true);
                    response.put("newBalance", user.getCleaningCoins());
                    response.put("coinsAwarded", coins);
                    
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
