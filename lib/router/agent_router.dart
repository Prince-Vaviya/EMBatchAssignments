import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/agent_screens.dart';

/// GoRouter provider with updated path /shell/details/TargetAcquired
final agentRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Requirement 4: Initial location updated to /shell/details/TargetAcquired (from /shell/details/Alex)
    initialLocation: '/shell/details/TargetAcquired',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AgentShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/shell/details/:target',
            builder: (context, state) {
              final target = state.pathParameters['target'] ?? 'TargetAcquired';
              return DetailScreen(target: target);
            },
          ),
        ],
      ),
    ],
  );
});
