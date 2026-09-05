import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';
import 'theme/neo_brutalist_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NeoBrutalistApp());
}

class NeoBrutalistApp extends StatelessWidget {
  const NeoBrutalistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoMart Product Listing',
      debugShowCheckedModeBanner: false,
      theme: NeoBrutalistTheme.theme,
      home: const ProductListScreen(),
    );
  }
}
