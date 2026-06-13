import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'dashboard.dart';
import 'get_started_page.dart';
import 'company_service.dart';

// Global theme notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  debugPrint("Initializing Firebase...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;

  debugPrint("Firebase initialized successfully.");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Flag to ensure sync only runs once per session
  bool _hasSynced = false;

  void _syncDataAfterAuth() {
    if (_hasSynced) return;
    _hasSynced = true;

    debugPrint("[FIRESTORE] User authenticated. Starting sync...");
    CompanyService().uploadCompanies().then((_) {
      debugPrint("[FIRESTORE] Sync successful. All companies overwritten.");
    }).catchError((e) {
      debugPrint("[FIRESTORE] Sync failed: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'CariIntern',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.deepPurple,
              brightness: Brightness.light,
              surface: const Color(0xFFF8F7FF),
              onSurface: const Color(0xFF311B92),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F7FF),
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(color: Color(0xFF311B92)),
              bodyMedium: TextStyle(color: Color(0xFF311B92)),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.deepPurpleAccent,
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E), // Darker surface for cards/containers
              onSurface: Colors.white, // Light font color
              onSurfaceVariant: Colors.white70,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark background
            textTheme: const TextTheme(
              displayLarge: TextStyle(color: Colors.white),
              displayMedium: TextStyle(color: Colors.white),
              displaySmall: TextStyle(color: Colors.white),
              headlineLarge: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(color: Colors.white),
              headlineSmall: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white60),
              labelLarge: TextStyle(color: Colors.white),
              labelMedium: TextStyle(color: Colors.white),
              labelSmall: TextStyle(color: Colors.white),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          themeMode: currentMode,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (snapshot.hasData && snapshot.data != null) {
                // User is signed in, trigger sync safely after build frame
                WidgetsBinding.instance.addPostFrameCallback((_) => _syncDataAfterAuth());

                return Dashboard2(
                  username: snapshot.data!.displayName ?? 
                            snapshot.data!.email?.split('@')[0] ?? 
                            'User',
                );
              }

              return const GetStartedPage();
            },
          ),
        );
      },
    );
  }
}
