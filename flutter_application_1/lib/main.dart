import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'themes/app_theme.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';
import 'service/auth_service.dart';

// Import your generated firebase options file
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NeuralScanApp());
}

class NeuralScanApp extends StatelessWidget {
  const NeuralScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuralScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: StreamBuilder(
        stream: AuthService.authStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: AppTheme.bgDeep,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.neonCyan),
              ),
            );
          }
          if (snapshot.hasData) return const HomeScreen();
          return const LoginScreen();
        },
      ),
    );
  }
}
