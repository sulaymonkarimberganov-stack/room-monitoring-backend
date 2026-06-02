import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Initialize connectivity service
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isConnected = _isConnectionAvailable(result);

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final wasConnected = _isConnected;
      _isConnected = _isConnectionAvailable(result);
      
      // Notify listeners only if connection status changed
      if (wasConnected != _isConnected) {
        _connectionController.add(_isConnected);
      }
    });
  }

  /// Check if connection is available
  bool _isConnectionAvailable(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
           result.contains(ConnectivityResult.wifi) ||
           result.contains(ConnectivityResult.ethernet);
  }

  /// Dispose service
  void dispose() {
    _subscription?.cancel();
    _connectionController.close();
  }
}

/// Connectivity banner widget
class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({
    super.key,
    required this.child,
  });

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = ConnectivityService();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _showBanner = false;
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Listen to connectivity changes
    _connectivityService.connectionStream.listen((isConnected) {
      if (!isConnected) {
        // Internet yo'q
        _wasDisconnected = true;
        setState(() => _showBanner = true);
        _animationController.forward();
      } else if (_wasDisconnected) {
        // Internet qayta ulandi
        _showSuccessBanner();
      }
    });
  }

  void _showSuccessBanner() {
    setState(() => _showBanner = true);
    _animationController.forward();

    // 3 soniyadan keyin banner ni yashirish
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _showBanner = false;
              _wasDisconnected = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showBanner)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBanner(),
            ),
          ),
      ],
    );
  }

  Widget _buildBanner() {
    final isConnected = _connectivityService.isConnected;
    
    return Material(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isConnected
              ? const Color(0xFF4CAF50) // Yashil
              : const Color(0xFFEF5350), // Qizil
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isConnected
                      ? 'Internet aloqasi qayta tiklandi'
                      : 'Internet aloqasi yo\'q',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!isConnected)
                TextButton(
                  onPressed: () async {
                    // Qayta tekshirish
                    final result = await Connectivity().checkConnectivity();
                    final isNowConnected = result.contains(ConnectivityResult.mobile) ||
                                          result.contains(ConnectivityResult.wifi);
                    
                    if (isNowConnected && mounted) {
                      _showSuccessBanner();
                    }
                  },
                  child: const Text(
                    'Tekshirish',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Connectivity checker mixin
mixin ConnectivityChecker<T extends StatefulWidget> on State<T> {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivityService.connectionStream.listen(
      (isConnected) {
        if (mounted) {
          onConnectivityChanged(isConnected);
        }
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  /// Override this method to handle connectivity changes
  void onConnectivityChanged(bool isConnected);

  /// Check if device is connected
  bool get isConnected => _connectivityService.isConnected;
}
