import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitpulse/main.dart';
import 'package:fitpulse/services/api_cache_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ApiCacheService fetches and saves to SharedPreferences', () async {
    final entries = await ApiCacheService.fetchArchiveEntries(forceRefresh: true);
    expect(entries.isNotEmpty, true);
    expect(entries.any((e) => e.category.name == 'space'), true);
    expect(entries.any((e) => e.category.name == 'dinosaur'), true);
    expect(entries.any((e) => e.category.name == 'solarpunk'), true);

    final lastSync = await ApiCacheService.getLastSyncTimestamp();
    expect(lastSync != null, true);
  });

  testWidgets('ApiFetcherScreen renders FutureBuilder and filters', (tester) async {
    await tester.pumpWidget(const ApiFetcherApp());
    await tester.pumpAndSettle();

    // Verify title and categories
    expect(find.text('ARCHIVE 🛰️'), findsOneWidget);
    expect(find.text('Space'), findsOneWidget);
    expect(find.text('Dinosaur'), findsOneWidget);
    expect(find.text('Solarpunk'), findsOneWidget);

    // Verify Space category items render
    expect(find.text('James Webb Deep Field Nebula Telemetry'), findsOneWidget);
  });
}
