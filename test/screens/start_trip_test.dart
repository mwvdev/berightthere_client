import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/middleware/trip_middleware.dart';
import 'package:berightthere_client/redux/reducers/reducers.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';
import 'package:berightthere_client/screens/start_trip.dart';

class MockTripProvider extends Mock implements TripProvider {}

void main() {
  MockTripProvider mockTripProvider;
  TripMiddleware tripMiddleware;

  Store<AppState> store;

  setUp(() {
    mockTripProvider = MockTripProvider();
    tripMiddleware = TripMiddleware(mockTripProvider);

    store = Store<AppState>(appStateReducer,
        middleware: [tripMiddleware], initialState: AppState());
  });

  testWidgets('Display a status message and a start trip button',
      (WidgetTester tester) async {
    await tester.pumpWidget(StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
            home: new StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) => StartTrip()))));

    expect(find.byKey(Key('startTripText')), findsOneWidget);
    expect(find.byKey(Key('startTripButton')), findsOneWidget);
  });

  testWidgets('Start trip button triggers check-in',
      (WidgetTester tester) async {
    var tripIdentifier = TripIdentifier('identifier');
    when(mockTripProvider.checkIn())
        .thenAnswer((_) => Future.value(tripIdentifier));

    await tester.pumpWidget(StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
            home: new StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) => StartTrip()))));

    await tester.tap(find.byKey(Key('startTripButton')));
    await tester.pump();

    verify(mockTripProvider.checkIn());
  });
}
