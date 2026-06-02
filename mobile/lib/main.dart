import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'core/services/connectivity_service.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'models/user_role.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/manager_dashboard_screen.dart';
import 'screens/cleaner_dashboard_screen.dart';
import 'services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (optional - only if google-services.json exists)
  FCMService? fcmService;
  try {
    await Firebase.initializeApp();
    
    // Initialize FCM
    fcmService = FCMService();
    await fcmService.initialize();
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('App will continue without Firebase features');
  }
  
  // Initialize Connectivity Service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(fcmService: fcmService),
    ),
  );
}

class MyApp extends StatefulWidget {
  final FCMService? fcmService;
  
  const MyApp({super.key, this.fcmService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    
    // Set up notification tap handler (only if FCM is available)
    if (widget.fcmService != null) {
      widget.fcmService!.onNotificationTap = (route, data) {
        navigatorKey.currentState?.pushNamed(route, arguments: data);
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Room Monitoring',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: ConnectivityBanner(
            child: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                // Show loading indicator while checking auth state
                if (auth.isLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // If not logged in, show login screen
                if (!auth.isLoggedIn) {
                  return const LoginScreen();
                }

                // Route to appropriate dashboard based on role
                final role = auth.getCurrentUserRole();
                
                switch (role) {
                  case UserRole.admin:
                    return const AdminDashboardScreen();
                  case UserRole.manager:
                    return const ManagerDashboardScreen();
                  case UserRole.cleaner:
                    return const CleanerDashboardScreen();
                  default:
                    return const CleanerDashboardScreen();
                }
              },
            ),
          ),
          routes: {
            '/admin-dashboard': (context) => const AdminDashboardScreen(),
            '/manager-dashboard': (context) => const ManagerDashboardScreen(),
            '/cleaner-dashboard': (context) => const CleanerDashboardScreen(),
          },
        );
      },
    );
  }
}
