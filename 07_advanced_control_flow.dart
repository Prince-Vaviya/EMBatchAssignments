// Sealed class hierarchy for pattern matching test
sealed class Shape {}

class Square extends Shape {
  final double side;
  Square(this.side);
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

class Rectangle extends Shape {
  final double w, h;
  Rectangle(this.w, this.h);
}

void main() {
  // 1. Advanced Switch Statements & Switch Expressions with Guard Clauses (when)
  Object response = (statusCode: 200, data: {"user": "Alice"});

  String responseStatus = switch (response) {
    (statusCode: 200, data: {"user": String user}) => "Success: $user",
    (statusCode: 404, data: _) => "Not Found",
    (statusCode: int code, data: _) when code >= 500 && code < 600 =>
      "Server Error: $code",
    _ => "Unknown Error",
  };
  print('--- 1. Pattern Matching & Guard Clauses ---');
  print('Response status: $responseStatus\n');

  // 2. Sealed Classes & Exhaustiveness Checking with Switch
  print('--- 2. Sealed Classes & Exhaustive Switch ---');
  Shape currentShape = Circle(5.0);

  double area = switch (currentShape) {
    Square(:final side) => side * side,
    Circle(:final radius) => 3.14159 * radius * radius,
    Rectangle(:final w, :final h) => w * h,
  };
  print('Calculated Area: $area\n');

  // 3. Destructuring in for-in Loops
  print('--- 3. Destructuring in for-in Loops ---');
  var entries = [
    (id: 1, info: ['Admin', 'Active']),
    (id: 2, info: ['User', 'Pending']),
  ];

  for (var (id: id, info: [role, ...]) in entries) {
    print('Entry ID: $id, Role: $role');
  }
  print('');

  // 4. Labeled Loop Control (break & continue across outer/inner loops)
  print('--- 4. Labeled Loop Control ---');
  outerLoop:
  for (int outer = 1; outer <= 3; outer++) {
    for (int inner = 1; inner <= 3; inner++) {
      print('outer: $outer, inner: $inner (product: ${outer * inner})');
      if (outer * inner == 4) {
        print('Breaking outerLoop at outer=$outer, inner=$inner');
        break outerLoop;
      }
    }
  }
  print('');

  // 5. Advanced assert Statements
  print('--- 5. Advanced assert Statements ---');
  int userAge = 15;
  try {
    assert(
      userAge >= 18,
      "Access denied: User is $userAge years old, minimum required is 18.",
    );
    print('User age validated: $userAge');
  } catch (e) {
    print('Assert failed: $e');
  }
}
