// Helper class for required & optional named parameter rules
class APIConfig {
  final String endpoint;
  final int timeoutSeconds;
  final bool enableLogs;

  APIConfig({
    required this.endpoint,
    this.timeoutSeconds = 30,
    this.enableLogs = false,
  });

  void display() {
    print(
      'APIConfig -> Endpoint: $endpoint, Timeout: ${timeoutSeconds}s, Logs: $enableLogs',
    );
  }
}

// 1. Combining Positional and Named Parameters
// Note: Dart parameter lists can have positional parameters followed by EITHER optional positional [...] OR named {...} parameters.
void sendNotification(
  String recipient, {
  String message = "Default Hello",
  bool urgent = false,
  required String sender,
}) {
  print('From: $sender -> To: $recipient | Msg: $message | Urgent: $urgent');
}

// 2. First-Class & Anonymous Functions (Higher-Order Functions)
List<int> customMap(List<int> list, int Function(int) action) {
  List<int> result = [];
  for (var item in list) {
    result.add(action(item));
  }
  return result;
}

// 3. Lexical Closures (State Encapsulation)
int Function() createCounter() {
  int count = 0; // Lexically captured variable
  return () {
    count++;
    return count;
  };
}

void main() {
  print('--- APIConfig Demo ---');
  var config = APIConfig(endpoint: "https://api.example.com/v1");
  config.display();
  print('');

  // 1. Call sendNotification
  print('--- 1. sendNotification ---');
  sendNotification(
    "dev@example.com",
    sender: "Server Monitor",
    message: "CPU Usage High",
    urgent: true,
  );
  sendNotification("user@example.com", sender: "Newsletter");
  print('');

  // 2. Call customMap using inline arrow function
  print('--- 2. Higher-Order customMap ---');
  List<int> original = [1, 2, 3, 4, 5];
  List<int> squared = customMap(original, (x) => x * x);
  print('Original: $original');
  print('Squared: $squared\n');

  // 3. Lexical Closures & State Isolation
  print('--- 3. Lexical Closures (State Isolation) ---');
  var counterA = createCounter();
  var counterB = createCounter();

  print('counterA call 1: ${counterA()}'); // 1
  print('counterA call 2: ${counterA()}'); // 2
  print('counterB call 1: ${counterB()}'); // 1 (proves state isolation)
  print('counterA call 3: ${counterA()}'); // 3
}
