import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/providers/location_provider.dart';
import 'package:berightthere_client/redux/location.dart';

class MockGeolocator extends Mock implements Geolocator {}

class MockStream extends Mock implements Stream<Position> {}

class MockStreamSubscription extends Mock
    implements StreamSubscription<Position> {}

void main() {
  test('subscribe triggers callback when new position available', () async {
    var position = Position(latitude: 53, longitude: 13);
    var positionStream = Stream.fromIterable([position]);

    final geolocator = MockGeolocator();
    when(geolocator.getPositionStream(any)).thenAnswer((_) => positionStream);

    final completer = Completer();

    void locationChangedCallback(Location location) {
      expect(location.latitude, equals(position.latitude));
      expect(location.longitude, equals(position.longitude));

      completer.complete();
    }

    LocationProvider(geolocator).subscribe(locationChangedCallback);

    expect(completer.future, completes);
  });
}
