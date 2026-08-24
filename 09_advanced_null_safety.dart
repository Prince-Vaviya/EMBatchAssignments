// 1. Sound Null Safety & Late Initialization Lifecycle
class DatabaseManager {
  // 'late' variable initialization deferred until first read
  late final String connectionString = _initConnection();

  String _initConnection() {
    print('Connecting to Database...');
    return "postgres://localhost:5432/db";
  }
}

// 2. The Never Type for Exhaustive Error Handling
Never failWithUnreachable(String reason) {
  throw ArgumentError("Fatal Application Error: $reason");
}

// Helper function testing type promotion limits
void processInput(Object? input) {
  // 3. Type Promotion & Fail-Fast Guards using Never
  if (input == null) {
    failWithUnreachable("Input cannot be null");
  }

  // Type Promotion in effect: 'input' is automatically promoted from Object? to Object (non-nullable)
  print('Input type promoted length: ${input.toString().length}');
}

class Cache {
  String? _cachedData;

  Cache([this._cachedData]);

  void validateCache() {
    // Note: Private fields CANNOT be type-promoted automatically because 
    // Dart cannot guarantee another method won't mutate the field mid-execution.
    
    // Fix field promotion limitation by copying to a local variable:
    final localData = _cachedData;
    if (localData != null) {
      // localData is safely promoted to String here
      print('Cache data length: ${localData.length}');
    } else {
      print('Cache is empty.');
    }
  }
}

void main() {
  print('--- 1. Late Initialization Lifecycle ---');
  DatabaseManager db = DatabaseManager();
  print('DatabaseManager created (connectionString not yet initialized)');
  print('Accessing connectionString: ${db.connectionString}\n');

  print('--- 2 & 3. Never Type & Type Promotion ---');
  processInput("Hello Dart");
  try {
    processInput(null);
  } catch (e) {
    print('Caught error from Never function: $e\n');
  }

  print('--- Cache Local Variable Type Promotion ---');
  Cache cache = Cache("Cached Content");
  cache.validateCache();
  print('');

  // 4. Late Initialization Edge Case
  print('--- 4. Late Initialization Edge Case ---');
  late String unassignedText;
  void readLateVar() {
    print(unassignedText);
  }

  try {
    readLateVar(); // Triggers LateInitializationError at runtime
  } catch (e) {
    print('Observed LateInitializationError: $e');
  }
  unassignedText = "Initialized";
  print('unassignedText after initialization: $unassignedText\n');

  // 5. Null-Aware Operators Combined (??, ??=, ?.)
  print('--- 5. Combined Null-Aware Operators ---');
  Map<String, List<int>?>? complexData;
  int scoreCount = complexData?['scores']?.length ?? -1;
  print('Scores count (null root): $scoreCount');

  complexData = {
    'scores': [95, 88, 92],
  };
  scoreCount = complexData['scores']?.length ?? -1;
  print('Scores count (populated): $scoreCount\n');

  // 6. Bang Operator (!) Safety Boundary
  print('--- 6. Bang Operator (!) ---');
  String? conditionalNullable = "Dart 3 Sound Null Safety";
  if (conditionalNullable != null) {
    print('Bang operator uppercase: ${conditionalNullable!.toUpperCase()}');
  }
}
