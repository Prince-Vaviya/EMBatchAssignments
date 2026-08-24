void main() {
  // 1. var Keyword

  var cityName = "Tokyo";

  print('cityName: $cityName');
  print('runtimeType: ${cityName.runtimeType}\n');

  // 2. Object vs dynamic

  Object objVal = 42;
  print('objVal: $objVal (${objVal.runtimeType})');
  // objVal.nonExistentMethod(); // COMPILE-TIME ERROR: The method 'nonExistentMethod' isn't defined for the class 'Object'.

  dynamic dynVal = "Hello";
  dynVal = 100;
  print('dynVal reassigned: $dynVal (${dynVal.runtimeType})');

  dynVal
      .toUpperCase(); // RUNTIME ERROR: NoSuchMethodError (int has no toUpperCase method)

  // 3. final vs const

  final DateTime now = DateTime.now();
  const double pi = 3.14159;
  print('final now: $now');
  print('const pi: $pi');

  // 4. int & double

  int age = 25;
  double temperature = 98.6;
  double result = temperature / age;
  print('temperature / age = $temperature / $age = $result\n');

  // 5. String & Interpolation

  String firstName = "Ada";
  String lastName = "Lovelace";
  String interpolated =
      "User: $firstName $lastName (Length: ${(firstName + " " + lastName).length})";
  print(interpolated + '\n');

  // 6. bool

  print('--- 6. bool ---');
  bool isLoggedIn = false;
  print('Initial isLoggedIn: $isLoggedIn');
  isLoggedIn = !isLoggedIn;
  print('Toggled isLoggedIn: $isLoggedIn\n');

  // 7. Runes & UTF-32

  print('--- 7. Runes & UTF-32 ---');
  String emojiStr = '🎯';
  print('Emoji String: $emojiStr');
  print('UTF-16 Code Units: ${emojiStr.codeUnits}');
  print('Runes (UTF-32): ${emojiStr.runes.toList()}');
}
