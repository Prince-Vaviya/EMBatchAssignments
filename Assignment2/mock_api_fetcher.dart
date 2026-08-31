import 'dart:async';

// ============================================================================
// ASSIGNMENT 2: ASYNCHRONOUS DART, NULL SAFETY & ERROR HANDLING
// ============================================================================

/// Model class representing a User profile received from an API.
/// Demonstrates Null Safety with nullable fields (email, phone, address).
class User {
  final int id;
  final String name;
  final String? email;   // Nullable field (may or may not be provided by API)
  final String? phone;   // Nullable field
  final String? address; // Nullable field

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
  });

  /// Factory constructor to safely parse JSON Map with null safety checks.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0, // Fallback to 0 if id is null
      name: json['name'] as String? ?? 'Anonymous User', // Fallback name
      email: json['email'] as String?, // Remains null if missing
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );
  }

  /// Displays user details using null-aware operators.
  void displayInfo() {
    print('👤 User ID: $id');
    print('   Name: $name');
    
    // Using ?? (if-null operator) to provide friendly fallback text
    print('   Email: ${email ?? "Not provided"}');
    print('   Phone: ${phone ?? "Not provided"}');
    print('   Address: ${address ?? "Not provided"}');
  }
}

/// Simulated API Service using Future and async/await.
class MockApiService {
  /// Simulates fetching user data from a remote server with network delay.
  static Future<Map<String, dynamic>> fetchUserData(int userId) async {
    print('\n🌐 Fetching data for User ID: $userId from remote server...');
    
    // Simulate a 1.5-second network latency
    await Future.delayed(const Duration(milliseconds: 1500));

    // Case 1: Successful response with complete data
    if (userId == 1) {
      return {
        'id': 1,
        'name': 'Prince Vaviya',
        'email': 'prince@example.com',
        'phone': '+91 98765 43210',
        'address': 'Surat, Gujarat',
      };
    }

    // Case 2: Successful response with missing/null fields (Testing Null Safety)
    if (userId == 2) {
      return {
        'id': 2,
        'name': 'John Doe',
        'email': null, // Email is intentionally null
        'phone': null, // Phone is missing
        // address is completely omitted
      };
    }

    // Case 3: Simulated server error / user not found (Testing Error Handling)
    if (userId == 404) {
      throw Exception('HTTP 404: User with ID $userId not found on server.');
    }

    // Default error for unknown IDs
    throw TimeoutException('Server took too long to respond. Connection timeout.');
  }
}

/// Main function to test all scenarios:
/// 1. Success with complete data
/// 2. Success with null/missing values
/// 3. Handling API errors gracefully
Future<void> main() async {
  print('=====================================================');
  print('🚀 DART ASYNC, NULL SAFETY & ERROR HANDLING DEMO');
  print('=====================================================');

  // Test Case 1: Fetching complete user data
  await loadAndDisplayUser(1);

  // Test Case 2: Fetching user data containing null fields
  await loadAndDisplayUser(2);

  // Test Case 3: Handling 404 Not Found error
  await loadAndDisplayUser(404);

  // Test Case 4: Handling Timeout error
  await loadAndDisplayUser(999);

  print('\n=====================================================');
  print('✅ All mock API requests completed safely!');
  print('=====================================================');
}

/// Helper function to demonstrate try-catch-finally, async/await, and null handling.
Future<void> loadAndDisplayUser(int userId) async {
  try {
    // 1. Await the Future from mock API
    final Map<String, dynamic> data = await MockApiService.fetchUserData(userId);

    // 2. Parse data into Model
    final user = User.fromJson(data);

    // 3. Display user details
    print('✅ Data fetched successfully:');
    user.displayInfo();

  } on TimeoutException catch (e) {
    // Handling specific network timeout exception
    print('⏱️ Timeout Error: ${e.message}');
  } catch (e) {
    // Handling any general exception
    print('❌ Error occurred: $e');
  } finally {
    // Always runs regardless of success or failure
    print('--- Request cycle finished for ID $userId ---');
  }
}
