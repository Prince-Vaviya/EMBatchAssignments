import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitpulse/main.dart';

void main() {
  testWidgets('Full 3-screen named route flow & registration validation', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const NeoRegisterApp());
    await tester.pumpAndSettle();

    // 1. Verify Home Screen loaded
    expect(find.text('COMMUNITY ⚡'), findsOneWidget);
    expect(find.text('Start Registration Form ✍️'), findsOneWidget);

    // 2. Tap CTA to navigate to Form screen ('/form')
    await tester.tap(find.text('Start Registration Form ✍️'));
    await tester.pumpAndSettle();

    // Verify Form Screen
    expect(find.text('MEMBER REGISTRATION 📝'), findsOneWidget);

    // 3. Try submitting empty form to trigger validations
    final submitBtn = find.text('Generate Official ID Pass ➔');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email address is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // 4. Fill form with valid credentials
    await tester.enterText(find.byType(TextFormField).at(0), 'Guido van Rossum');
    await tester.enterText(find.byType(TextFormField).at(1), 'guido@python.org');
    await tester.enterText(find.byType(TextFormField).at(2), 'SecretPass123!');
    await tester.enterText(find.byType(TextFormField).at(3), 'SecretPass123!');

    // Agree to terms
    await tester.tap(find.text('I agree to the Community Code of Conduct & verified identity terms.'));
    await tester.pumpAndSettle();

    // Submit valid form
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // 5. Verify Detail Screen ('/detail') with passed UserRegistration arguments
    expect(find.text('MEMBERSHIP PASS 🎖️'), findsOneWidget);
    expect(find.text('Guido van Rossum'), findsOneWidget);
    expect(find.text('guido@python.org'), findsOneWidget);
    expect(find.text('REGISTRATION VERIFIED & ACTIVE'), findsOneWidget);

    // 6. Return to Home via named route popUntil
    await tester.tap(find.text('Home Feed ➔'));
    await tester.pumpAndSettle();

    expect(find.text('COMMUNITY ⚡'), findsOneWidget);
  });
}
