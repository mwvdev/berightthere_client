import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/provider/trip_provider.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final config = Config("https://localhost:8080/api");

  test('checkIn returns a trip identifier when it succeeds', () async {
    final client = MockClient();

    when(client.get('https://localhost:8080/api/trip/checkin')).thenAnswer(
        (_) async => http.Response('{"identifier": "tripIdentifier"}', 200));

    var tripIdentifier = await TripProvider(client, config).checkIn();

    expect(tripIdentifier.identifier, 'tripIdentifier');
  });

  test('checkIn throws when unsuccessful', () {
    final client = MockClient();
    var reasonPhrase = 'This is the reason';

    when(client.get('https://localhost:8080/api/trip/checkin')).thenAnswer(
        (_) async => http.Response('', 500, reasonPhrase: reasonPhrase));

    expect(
        () => TripProvider(client, config).checkIn(),
        throwsA(const TypeMatcher<CheckInException>().having((e) => e.message,
            "message contains reason phrase", contains(reasonPhrase))));
  });
}
