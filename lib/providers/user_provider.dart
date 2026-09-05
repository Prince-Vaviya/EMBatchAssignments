import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(UserProfile(name: '', age: 0, isOnboarded: false));

  void completeOnboarding({required String name, required int age}) {
    state = UserProfile(
      name: name,
      age: age,
      isOnboarded: true,
    );
  }

  void updateProfile({String? name, int? age}) {
    state = state.copyWith(
      name: name,
      age: age,
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
