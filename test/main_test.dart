import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:berightthere_client/main.dart';
import 'package:berightthere_client/start_trip.dart';
import 'package:berightthere_client/service/trip_service.dart';

class MockTripService extends Mock implements TripService {}

void main() {
  testWidgets('Displays the start trip widget', (WidgetTester tester) async {
    final tripService = MockTripService();

    await tester.pumpWidget(BeRightThereApp(tripService));

    expect(find.byType(StartTrip), findsOneWidget);
  });
}
