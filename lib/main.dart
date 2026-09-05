import 'package:flutter/material.dart';
import 'screens/api_fetcher_screen.dart';
import 'theme/neo_brutalist_pastel_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ApiFetcherApp());
}

class ApiFetcherApp extends StatelessWidget {
  const ApiFetcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API & Cache Archive',
      debugShowCheckedModeBanner: false,
      theme: NeoTheme.themeData,
      home: const ApiFetcherScreen(),
    );
  }
}
