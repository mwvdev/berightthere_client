import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:berightthere_client/model/trip_identifier.dart';
import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/provider/trip_provider.dart';
import 'package:berightthere_client/screens/be_right_there_app.dart';
import 'package:berightthere_client/screens/start_trip.dart';
import 'package:berightthere_client/screens/track_location.dart';

class MockTripProvider extends Mock implements TripProvider {}

void main() {
  group('Displays the start trip widget when checking in', () {
    void testStartTripDisplayed(TripState tripState) {
      testWidgets('Displays the start trip widget when state is $tripState',
          (WidgetTester tester) async {
        final tripModel = TripModel();
        tripModel.tripState = tripState;

        await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider(
            builder: (context) => tripModel,
            child: BeRightThereApp(MockTripProvider()),
          ),
        ));

        expect(find.byType(StartTrip), findsOneWidget);
      });
    }

    final states = [TripState.ready, TripState.checkingIn, TripState.checkInFailed];
    states.forEach((tripState) => testStartTripDisplayed(tripState));
  });

  testWidgets('Displays the track location widget when checked in',
      (WidgetTester tester) async {
    final tripModel = TripModel();
    tripModel.tripIdentifier = TripIdentifier('identifier');
    tripModel.tripState = TripState.checkedIn;

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        builder: (context) => tripModel,
        child: BeRightThereApp(MockTripProvider()),
      ),
    ));

    expect(find.byType(TrackLocation), findsOneWidget);
  });
}
