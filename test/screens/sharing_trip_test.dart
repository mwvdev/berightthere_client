import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/share_provider.dart';
import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/reducers/reducers.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';
import 'package:berightthere_client/screens/sharing_trip.dart';

class MockShareProvider extends Mock implements ShareProvider {}

class MockTripProvider extends Mock implements TripProvider {}

void main() {
  MockTripProvider mockTripProvider;
  MockShareProvider mockShareProvider;

  AppState appState;
  Store<AppState> store;

  setUp(() {
    mockTripProvider = MockTripProvider();

    mockShareProvider = MockShareProvider();

    appState = AppState(tripIdentifier: TripIdentifier('identifier'));
    store = Store<AppState>(appStateReducer, initialState: appState);
  });

  testWidgets('Displays a status message and a share trip button',
      (WidgetTester tester) async {
    await tester.pumpWidget(StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
            home: SharingTrip(mockTripProvider, mockShareProvider))));

    expect(find.byKey(Key('sharingTripText')), findsOneWidget);
    expect(find.byKey(Key('shareTripButton')), findsOneWidget);
  });

  testWidgets('Share trip button triggers sharing intent',
      (WidgetTester tester) async {
    final tripUrl = 'tripUrl';
    when(mockTripProvider.getTripUrl(appState.tripIdentifier)).thenReturn(tripUrl);

    await tester.pumpWidget(StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
            home: SharingTrip(mockTripProvider, mockShareProvider))));

    await tester.tap(find.byKey(Key('shareTripButton')));
    await tester.pump();

    var shareText = verify(mockShareProvider.share(captureAny)).captured.single;
    expect(shareText, contains(tripUrl));
  });
}
