# Assignment 2: Dart Asynchronous Programming & Null Safety

## 📌 Overview
This assignment demonstrates core Dart concepts including **Null Safety**, **`Future`**, **`async` / `await`**, and robust **Error Handling (`try-catch-finally`)** when fetching and parsing mock API data.

---

## 🎯 Key Concepts Implemented

1. **Null Safety**:
   - Declaring nullable fields (`String? email`, `String? phone`, `String? address`).
   - Using the null-coalescing operator (`??`) to provide default/fallback values when fields are missing or `null`.
   - Safe map casting with `as String?` and `as int?`.

2. **Asynchronous Operations (`Future`, `async`, `await`)**:
   - `MockApiService.fetchUserData(int id)` returns a `Future<Map<String, dynamic>>`.
   - Simulated network delay using `await Future.delayed(...)`.
   - Sequential execution using `await loadAndDisplayUser(...)`.

3. **Error & Exception Handling**:
   - `try-catch-finally` block to catch network errors.
   - Specific exception handling (`on TimeoutException catch (e)`).
   - `finally` block ensuring cleanup or completion logs run every time.

---

## 🧪 Test Scenarios Covered

| Test Case | Scenario | Expected Behavior |
|---|---|---|
| **User ID: 1** | Complete User Data | Fetches and displays all fields properly. |
| **User ID: 2** | Missing / Null Fields | Uses fallback text (`"Not provided"`) without crashing. |
| **User ID: 404** | User Not Found | Throws an `Exception` and catches HTTP 404 error cleanly. |
| **User ID: 999** | Server Timeout | Catches `TimeoutException` and displays timeout alert. |

---

## 🚀 How to Run

Run the Dart script from the terminal:

```bash
dart run Assignment2/mock_api_fetcher.dart
```
