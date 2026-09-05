import 'package:flutter/material.dart';
import 'screens/neo_detail_screen.dart';
import 'screens/neo_home_screen.dart';
import 'screens/neo_registration_form_screen.dart';
import 'theme/neo_brutalist_pastel_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NeoRegisterApp());
}

class NeoRegisterApp extends StatelessWidget {
  const NeoRegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo-Brutalist Registration',
      debugShowCheckedModeBanner: false,
      theme: NeoTheme.themeData,
      // Named routes configuration for 3-screen architecture
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/form': (context) => const RegistrationFormScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}
