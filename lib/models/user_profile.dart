class UserProfile {
  final String name;
  final int age;
  final bool isOnboarded;

  UserProfile({
    required this.name,
    required this.age,
    this.isOnboarded = false,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    bool? isOnboarded,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}
