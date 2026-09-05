import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpulse/providers/agent_provider.dart';
import 'package:fitpulse/main.dart';

void main() {
  test('userProvider initial state is Agent 007', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Initial state check
    expect(container.read(userProvider), 'Agent 007');

    // Trigger state change
    container.read(userProvider.notifier).set('Supreme Ninja');
    expect(container.read(userProvider), 'Supreme Ninja');
  });

  testWidgets('Secret Agent App renders and activates alias', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AgentIntelligenceApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify before clicking: Agent 007: TargetAcquired
    expect(find.text('Agent 007: TargetAcquired'), findsOneWidget);
    expect(find.text('Activate Alias'), findsOneWidget);

    // 2. Click "Activate Alias" button
    await tester.tap(find.text('Activate Alias'));
    await tester.pumpAndSettle();

    // 3. Verify after clicking: Supreme Ninja: TargetAcquired
    expect(find.text('Supreme Ninja: TargetAcquired'), findsOneWidget);
  });
}
