import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/providers/trip_provider_exception.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final config =
      Config("https://localhost:8080");

  http.Client client;

  setUp(() {
    client = MockClient();
  });

  test('checkIn returns a trip identifier when it succeeds', () async {
    when(client.get('https://localhost:8080/api/trip/checkin')).thenAnswer(
        (_) async => http.Response('{"identifier": "tripIdentifier"}', 200));

    var tripIdentifier = await TripProvider(client, config).checkIn();

    expect(tripIdentifier.identifier, 'tripIdentifier');
  });

  test('checkIn throws when unsuccessful', () {
    var reasonPhrase = 'This is the reason';

    when(client.get('https://localhost:8080/api/trip/checkin')).thenAnswer(
        (_) async => http.Response('', 500, reasonPhrase: reasonPhrase));

    expect(
        () => TripProvider(client, config).checkIn(),
        throwsA(const TypeMatcher<TripProviderException>().having(
            (e) => e.message,
            "message contains reason phrase",
            contains(reasonPhrase))));
  });

  test('addLocation reports a location', () async {
    final tripIdentifier = TripIdentifier('identifier');
    final location = Location(55.6739062, 12.5556993);

    when(client.get('https://localhost:8080/api/trip/'
            '${tripIdentifier.identifier}/'
            'addLocation/'
            '${location.latitude}/'
            '${location.longitude}'))
        .thenAnswer((_) async => http.Response('', 200));

    await TripProvider(client, config).addLocation(tripIdentifier, location);
  });

  test('addLocation throws when unsuccessful', () async {
    var reasonPhrase = 'This is the reason';

    final tripIdentifier = TripIdentifier('identifier');
    final location = Location(55.6739062, 12.5556993);

    when(client.get('https://localhost:8080/api/trip/'
            '${tripIdentifier.identifier}/'
            'addLocation/'
            '${location.latitude}/'
            '${location.longitude}'))
        .thenAnswer(
            (_) async => http.Response('', 500, reasonPhrase: reasonPhrase));

    expect(
        () =>
            TripProvider(client, config).addLocation(tripIdentifier, location),
        throwsA(const TypeMatcher<TripProviderException>().having(
            (e) => e.message,
            "message contains reason phrase",
            contains(reasonPhrase))));
  });

  test('getTripUri generates a valid Uri from trip identifier', () {
    final tripIdentifier = TripIdentifier('identifier');

    var tripUri = TripProvider(client, config).getTripUrl(tripIdentifier);

    expect(
        tripUri,
        equals('https://localhost:8080/trip/${tripIdentifier.identifier}'));
  });

  test('getTripUri throws when trip identifier is invalid', () {
    final tripIdentifier = null;

    expect(() => TripProvider(client, config).getTripUrl(tripIdentifier),
        throwsA(const TypeMatcher<ArgumentError>()));
  });
}
