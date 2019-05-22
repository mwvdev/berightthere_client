import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:berightthere_client/checkin.dart';
import 'package:berightthere_client/model/trip_identifier.dart';
import 'package:berightthere_client/start_trip.dart';
import 'package:berightthere_client/service/trip_service.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockTripService extends Mock implements TripService {}

void main() {
  testWidgets('Display a status message and a start trip button',
      (WidgetTester tester) async {
    final mockNavigatorObserver = MockNavigatorObserver();

    final tripService = MockTripService();
    final futureTripIdentifier = Future.value(new TripIdentifier("identifier"));

    when(tripService.checkin()).thenAnswer((_) => futureTripIdentifier);

    await tester.pumpWidget(MaterialApp(
      home: StartTrip(tripService),
      navigatorObservers: [mockNavigatorObserver],
    ));

    expect(find.text('Ready to start trip!'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any));
    expect(find.byType(Checkin), findsOneWidget);
  });
}
