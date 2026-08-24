class UserProfile {
  // 1. late Keyword
  late String bio; // Delayed initialization

  void initBio() {
    bio = "Developer from NYC";
  }
}

// 2. Never Type
Never throwFatalError(String msg) {
  throw Exception("Fatal Error: $msg");
}

void main() {
  // 1. late Keyword test
  UserProfile profile = UserProfile();
  profile.initBio();
  print('Profile Bio: ${profile.bio}\n');

  // 3. Non-Nullable vs Nullable Types (?)
  int nonNullable = 10;
  int? nullableVal = null;
  print('nonNullable: $nonNullable, nullableVal: $nullableVal');

  // 4. If-Null Operator (??) & Null-Aware Assignment (??=)
  int result = nullableVal ?? 0; // Default fallback
  nullableVal ??= 5; // Assigns 5 only if null
  print('result (?? 0): $result');
  print('nullableVal after ??= 5: $nullableVal\n');

  // 5. Null-Aware Access (?.) & Bang Operator (!)
  String? text;
  print('text?.length (when null): ${text?.length}');

  text = "Dart";
  print('text!.length (after assigning "Dart"): ${text!.length}\n');

  // 6. Type Promotion
  Object data = "Smart Cast";
  if (data is String) {
    // data is automatically promoted from Object to String here
    print('Type Promoted String: ${data.toUpperCase()}');
  }
}
