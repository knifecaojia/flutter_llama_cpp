// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:simple_llama_cpp_test_gemini/main.dart';

void main() {
  testWidgets('Image inference app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed.
    expect(find.text('LLaMA CPP Dart - Real Inference'), findsOneWidget);
    
    // Verify that the status text is displayed (could be initializing or ready).
    final statusTextFinder = find.textContaining('LLaMA');
    expect(statusTextFinder, findsAtLeastNWidgets(1));
    
    // Verify that the run inference button is displayed.
    expect(find.text('Run Inference'), findsOneWidget);
    
    // Verify that configuration information is displayed.
    expect(find.textContaining('Configuration:'), findsOneWidget);
    expect(find.textContaining('Model:'), findsOneWidget);
    expect(find.textContaining('MMProj:'), findsOneWidget);
    expect(find.textContaining('Image:'), findsOneWidget);
  });
}
