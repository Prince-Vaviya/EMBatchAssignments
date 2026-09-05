import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';
import '../screens/add_workout_screen.dart';
import '../screens/details_screen.dart';
import '../screens/main_scaffold_screen.dart';
import '../screens/onboarding_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final userProfile = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: userProfile.isOnboarded ? '/' : '/onboarding',
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == '/onboarding';
      if (!userProfile.isOnboarded && !isOnboarding) {
        return '/onboarding';
      }
      if (userProfile.isOnboarded && isOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MainScaffoldScreen();
        },
      ),
      GoRoute(
        path: '/add',
        builder: (BuildContext context, GoRouterState state) {
          return const AddWorkoutLoggerScreen();
        },
      ),
      GoRoute(
        path: '/details/:id',
        builder: (BuildContext context, GoRouterState state) {
          final String workoutId = state.pathParameters['id'] ?? '';
          return WorkoutDetailsScreen(workoutId: workoutId);
        },
      ),
    ],
  );
});
