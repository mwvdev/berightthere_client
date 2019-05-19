import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:berightthere_client/main.dart';

void main() {
  testWidgets('Display a welcome message and a button', (WidgetTester tester) async {
    await tester.pumpWidget(BeRightThereApp());

    expect(find.text('Ready to start trip!'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
