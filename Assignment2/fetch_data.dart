// Assignment 2: Fetch and display mock API data using Future, async/await, and Null Safety

// Model class representing a User
class User {
  final int id;
  final String name;
  final String? email; // Nullable: email may be missing
  final int? age;      // Nullable: age may be missing

  User({
    required this.id,
    required this.name,
    this.email,
    this.age,
  });
}

// Simulated API function that fetches user data by ID
Future<User> fetchUserData(int userId) async {
  print("Fetching data for User ID: $userId...");

  // Simulate network delay (1 second)
  await Future.delayed(Duration(seconds: 1));

  // Handle error case for invalid ID
  if (userId <= 0) {
    throw Exception("Invalid User ID: $userId. ID must be greater than 0.");
  }

  // Simulate mock database / API response
  if (userId == 1) {
    // Complete data
    return User(
      id: 1,
      name: "Alice Johnson",
      email: "alice@example.com",
      age: 24,
    );
  } else if (userId == 2) {
    // Partial data with null values
    return User(
      id: 2,
      name: "Bob Smith",
      email: null, // Null value
      age: null,   // Null value
    );
  } else {
    // Simulate user not found error
    throw Exception("User with ID $userId not found on server.");
  }
}

// Function to display user details safely with null handling
void displayUser(User? user) {
  // Check if the user object itself is null
  if (user == null) {
    print("No user data to display.\n");
    return;
  }

  print("--- User Details ---");
  print("ID    : ${user.id}");
  print("Name  : ${user.name}");
  
  // Using null-coalescing operator (??) to handle null fields safely
  print("Email : ${user.email ?? 'Not Provided'}");
  print("Age   : ${user.age ?? 'Not Specified'}");
  print("--------------------\n");
}

// Main function using async/await and try-catch
void main() async {
  print("=== Assignment 2: Mock API Data Fetcher ===\n");

  // Case 1: Fetch user with complete data
  try {
    User user1 = await fetchUserData(1);
    displayUser(user1);
  } catch (e) {
    print("Error: $e\n");
  }

  // Case 2: Fetch user with null/missing fields
  try {
    User user2 = await fetchUserData(2);
    displayUser(user2);
  } catch (e) {
    print("Error: $e\n");
  }

  // Case 3: Handle error when user is not found
  try {
    User user3 = await fetchUserData(99);
    displayUser(user3);
  } catch (e) {
    print("Error caught: $e\n");
  }

  // Case 4: Handle error for invalid user ID
  try {
    User user4 = await fetchUserData(-5);
    displayUser(user4);
  } catch (e) {
    print("Error caught: $e\n");
  }
}
