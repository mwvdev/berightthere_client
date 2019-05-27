import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:berightthere_client/model/trip_identifier.dart';
import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/screens/start_trip.dart';
import 'package:berightthere_client/provider/trip_provider.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockTripService extends Mock implements TripProvider {}

void main() {
  testWidgets('Display a status message and a start trip button',
      (WidgetTester tester) async {
    final tripProvider = MockTripService();

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        builder: (context) => TripModel(),
        child: StartTrip(tripProvider),
      ),
    ));

    expect(find.byKey(Key('startTripText')), findsOneWidget);
    expect(find.byKey(Key('startTripButton')), findsOneWidget);
  });

  testWidgets('Displays a progress indicator then success message on check-in',
      (WidgetTester tester) async {
    final completer = new Completer<TripIdentifier>();
    final tripProvider = MockTripService();
    when(tripProvider.checkIn()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        builder: (context) => TripModel(),
        child: StartTrip(tripProvider),
      ),
    ));

    await tester.tap(find.byKey(Key('startTripButton')));
    await tester.pump();

    expect(find.byKey(Key('progressIndicator')), findsOneWidget);
    verify(tripProvider.checkIn());

    completer.complete(TripIdentifier('identifier'));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('successText')), findsOneWidget);
  });

  testWidgets('Displays a circular progress indicator until future has error',
      (WidgetTester tester) async {
    final tripProvider = MockTripService();
    final completer = Completer<TripIdentifier>();
    when(tripProvider.checkIn()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        builder: (context) => TripModel(),
        child: StartTrip(tripProvider),
      ),
    ));

    await tester.tap(find.byKey(Key('startTripButton')));
    await tester.pump();

    expect(find.byKey(Key('progressIndicator')), findsOneWidget);

    completer.completeError('error');
    await tester.pumpAndSettle();

    expect(find.byKey(Key('failureText')), findsOneWidget);
    expect(find.byKey(Key('progressIndicator')), findsNothing);
  });
}
