// 1. Positional, Optional, Named, & Default Parameters
void buildUser(String id, {required String username, String role = "guest"}) {
  print('ID: $id, User: $username, Role: $role');
}

// 2. Arrow Function (=>)
int square(int n) => n * n;

// 3. First-Class Functions & Anonymous Functions
void executeAction(Function action) {
  action();
}

// 4. Lexical Closures
Function makeAdder(int addBy) {
  return (int i) => i + addBy; // Retains access to addBy
}

void main() {
  // 1. Call buildUser with required parameters
  print('--- 1. buildUser ---');
  buildUser("U101", username: "alice");
  buildUser("U102", username: "bob", role: "admin");
  print('');

  // 2. Arrow function
  print('--- 2. square ---');
  print('square(5) = ${square(5)}\n');

  // 3. Pass anonymous function into executeAction
  print('--- 3. executeAction ---');
  executeAction(() => print("Executing..."));
  print('');

  // 4. Closures
  print('--- 4. Closures ---');
  var add5 = makeAdder(5);
  print('add5(10) = ${add5(10)}');
}
