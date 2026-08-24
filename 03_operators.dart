class Student {
  String name = '';
  int score = 0;
  void display() => print('$name scored $score');
}

void main() {
  // 1. Arithmetic & Relational Operators
  int modResult = 17 % 4;
  int intDivResult = 17 ~/ 4;
  bool isGreaterOrEqual = (10 >= 10);

  print('17 % 4 = $modResult');
  print('17 ~/ 4 = $intDivResult');
  print('10 >= 10: $isGreaterOrEqual\n');

  // 2. Type Test (is, is!) & Type Cast (as)
  dynamic val = "Dart Language";
  if (val is String) {
    print('val is String: true');
  }

  String strVal = val as String;
  print('Length of string: ${strVal.length}\n');

  // 3. Logical & Ternary Operators
  bool hasTicket = true;
  bool hasId = false;
  print('hasTicket && hasId: ${hasTicket && hasId}');

  String status = hasTicket ? "Allowed" : "Denied";
  print('Status: $status\n');

  // 4. Cascade (..) & Null-Aware Cascade (?..)
  Student()
    ..name = 'John'
    ..score = 95
    ..display();

  Student? nullableStudent;
  nullableStudent
    ?..name = 'Jane'
    ..score = 88
    ..display();
  print('Nullable student cascade evaluated safely.');
}
