import 'package:flutter/material.dart';
import 'screens/todo_screen.dart';
import 'theme/pastel_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PastelTodoApp());
}

class PastelTodoApp extends StatelessWidget {
  const PastelTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Todo App',
      debugShowCheckedModeBanner: false,
      theme: PastelTheme.lightTheme,
      home: const TodoScreen(),
    );
  }
}
