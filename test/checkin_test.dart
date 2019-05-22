import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:berightthere_client/checkin.dart';
import 'package:berightthere_client/model/trip_identifier.dart';

void main() {
  testWidgets('Displays a circular progress indicator until future has value', (WidgetTester tester) async {
    var identifier = 'identifier';
    final futureTripIdentifier = Future.value(TripIdentifier(identifier));

    await tester.pumpWidget(MaterialApp(home: Checkin(futureTripIdentifier)));

    expect(find.text(identifier), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text(identifier), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Displays a circular progress indicator until future has error', (WidgetTester tester) async {
    final errorMessage = 'Error message to display';
    final completer = new Completer<TripIdentifier>();

    await tester.pumpWidget(MaterialApp(home: Checkin(completer.future)));

    expect(find.text(errorMessage), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.completeError(errorMessage);
    await tester.pump();

    expect(find.text(errorMessage), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
