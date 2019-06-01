import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:berightthere_client/model/trip_identifier.dart';
import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/provider/trip_provider.dart';
import 'package:berightthere_client/screens/track_location.dart';

class MockTripProvider extends Mock implements TripProvider {}

void main() {
  testWidgets('Displays the trip identifier', (WidgetTester tester) async {
    final tripIdentifier = TripIdentifier('identifier');

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        builder: (context) => TripModel(),
        child: TrackLocation(tripIdentifier),
      ),
    ));

    expect(find.byType(TrackLocation), findsOneWidget);
  });
}
