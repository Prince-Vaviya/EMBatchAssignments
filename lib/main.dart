import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/agent_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScope initializes Riverpod for the entire app tree
    const ProviderScope(
      child: AgentIntelligenceApp(),
    ),
  );
}

class AgentIntelligenceApp extends ConsumerWidget {
  const AgentIntelligenceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(agentRouterProvider);

    return MaterialApp.router(
      title: 'Secret Agent Intelligence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
      ),
      routerConfig: router,
    );
  }
}
