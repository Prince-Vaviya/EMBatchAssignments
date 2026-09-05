import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UserNotifier managing Secret Agent Alias state
class UserNotifier extends StateNotifier<String> {
  // Requirement 1: Initial state set to 'Agent 007' (fixed from 'Guest')
  UserNotifier() : super('Agent 007');

  // Method to update alias
  void set(String alias) {
    state = alias;
  }
}

/// userProvider StateNotifierProvider
final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier();
});
