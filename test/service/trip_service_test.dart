import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/service/trip_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final config = Config("https://localhost:8080/api");

  test('Checkin returns a trip identifier when it succeeds', () async {
    final client = MockClient();

    when(client.get('https://localhost:8080/api/trip/checkin')).thenAnswer(
        (_) async => http.Response('{"identifier": "tripIdentifier"}', 200));

    var tripIdentifier = await TripService(client, config).checkin();

    expect(tripIdentifier.identifier, 'tripIdentifier');
  });

  test('Checkin throws when unsuccessful', () {
    final client = MockClient();
    var reasonPhrase = 'This is the reason';

    when(client.get('https://localhost:8080/api/trip/checkin')).thenAnswer(
        (_) async => http.Response('', 500, reasonPhrase: reasonPhrase));

    expect(
        () => TripService(client, config).checkin(),
        throwsA(const TypeMatcher<CheckinException>().having((e) => e.message,
            "message contains reason phrase", contains(reasonPhrase))));
  });
}
