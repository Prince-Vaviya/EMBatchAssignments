void main() {
  // 1. List
  List<int> numbers = [10, 20, 30];
  numbers.add(40);
  numbers.remove(10);
  print('List: $numbers');
  print('Second item: ${numbers[1]}\n');

  // 2. Set
  Set<String> fruits = {"apple", "banana", "apple"};
  print('Set (unique entries): $fruits\n');

  // 3. Map
  Map<String, dynamic> student = {'name': 'Alex', 'grade': 'A'};
  student['age'] = 20;
  print('Map: $student\n');

  // 4. Type Conversion
  String strNum = "123";
  int parsedInt = int.parse(strNum);
  print('Parsed int: $parsedInt');

  double doubleVal = 45.67;
  String formattedDouble = doubleVal.toStringAsFixed(1);
  print('Formatted double (1 decimal): $formattedDouble');
}
