void main() {
  // 1. if / else if / else
  int score = 85;
  String grade;
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else {
    grade = 'F';
  }
  print('Score: $score, Grade: $grade\n');

  // 2. switch Statement & Switch Patterns (Dart 3+)
  Object shape = (10, 20); // Record type
  switch (shape) {
    case (int w, int h):
      print('Rectangle $w x $h\n');
    default:
      print('Unknown shape\n');
  }

  // 3. Loops (for, for-in, while, do-while)
  List<String> items = ['A', 'B', 'C'];

  print('Standard for loop:');
  for (int i = 0; i < items.length; i++) {
    print(items[i]);
  }

  print('\nFor-in loop:');
  for (var item in items) {
    print(item);
  }

  print('\nWhile loop:');
  int count = 1;
  while (count <= 3) {
    print(count);
    count++;
  }

  print('\nDo-while loop:');
  int doCount = 1;
  do {
    print(doCount);
    doCount++;
  } while (doCount <= 1);
  print('');

  // 4. break, continue, assert
  print('Loop with continue & break:');
  for (int i = 1; i <= 10; i++) {
    if (i == 5) {
      continue;
    }
    if (i == 8) {
      break;
    }
    print(i);
  }

  int speed = 50;
  assert(speed <= 100, "Speed limit exceeded");
  print('\nAssert passed for speed: $speed');
}
