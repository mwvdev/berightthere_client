import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/location_provider.dart';
import 'package:berightthere_client/providers/share_provider.dart';
import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/actions/trip_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/middleware/location_middleware.dart';
import 'package:berightthere_client/redux/middleware/trip_middleware.dart';
import 'package:berightthere_client/redux/reducers/reducers.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';
import 'package:berightthere_client/screens/be_right_there_app.dart';

class MockLocationProvider extends Mock implements LocationProvider {}

class MockShareProvider extends Mock implements ShareProvider {}

class MockTripProvider extends Mock implements TripProvider {}

void main() {
  MockTripProvider mockTripProvider;
  TripMiddleware tripMiddleware;

  MockLocationProvider mockLocationProvider;
  LocationMiddleware locationMiddleware;

  MockShareProvider mockShareProvider;

  setUp(() {
    mockTripProvider = MockTripProvider();
    tripMiddleware = TripMiddleware(mockTripProvider);

    mockLocationProvider = MockLocationProvider();
    locationMiddleware = LocationMiddleware(mockLocationProvider);

    mockShareProvider = MockShareProvider();
  });

  Store<AppState> createStore(AppState appState) {
    return Store<AppState>(appStateReducer,
        middleware: [tripMiddleware, locationMiddleware],
        initialState: appState);
  }

  Store<AppState> createDefaultStore() {
    return createStore(AppState());
  }

  testWidgets('Displays the start trip screen prior to checked-in',
      (WidgetTester tester) async {
    await tester.pumpWidget(BeRightThereApp(
        mockTripProvider, mockShareProvider, createDefaultStore()));

    expect(find.byKey(Key('startTripScreen')), findsOneWidget);
  });

  testWidgets('Shows loading screen while checking in',
      (WidgetTester tester) async {
    final appState = AppState(isLoading: true);

    await tester.pumpWidget(BeRightThereApp(
        mockTripProvider, mockShareProvider, createStore(appState)));

    expect(find.byKey(Key('loadingScreen')), findsOneWidget);
  });

  testWidgets('Shows loading screen while checking in and first location',
      (WidgetTester tester) async {
    final location = Location(55.6739062, 12.5556993);

    final appState = AppState(isLoading: true);
    var store = createStore(appState);

    when(mockTripProvider.addLocation(any, any))
        .thenAnswer((_) => Future.value());

    await tester.pumpWidget(
        BeRightThereApp(mockTripProvider, mockShareProvider, store));

    expect(find.byKey(Key('loadingScreen')), findsOneWidget);

    store.dispatch(CheckInSucceededAction(TripIdentifier('identifier')));
    store.dispatch(LocationChangedAction(location));
    await tester.pump();

    expect(find.byKey(Key('sharingTripScreen')), findsOneWidget);
  });
}
