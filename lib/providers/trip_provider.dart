import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/providers/trip_provider_exception.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class TripProvider {
  final http.Client _client;
  final Config _config;

  TripProvider(this._client, this._config);

  Future<TripIdentifier> checkIn() async {
    final response =
        await _client.get('${_config.beRightThereAuthority}/api/trip/checkin');

    if (response.statusCode == 200) {
      return TripIdentifier.fromJson(json.decode(response.body));
    } else {
      throw TripProviderException(
          'Failed to checkin. Reason: ${response.reasonPhrase}');
    }
  }

  Future addLocation(TripIdentifier tripIdentifier, Location location) async {
    final response =
        await _client.post('${_config.beRightThereAuthority}/api/trip/'
            '${tripIdentifier.identifier}/'
            'addLocation/'
            '${location.latitude}/'
            '${location.longitude}');

    if (response.statusCode != 200) {
      throw TripProviderException(
          'Failed to report location. Reason: ${response.reasonPhrase}');
    }
  }

  String getTripUrl(TripIdentifier tripIdentifier) {
    if (tripIdentifier == null) {
      throw ArgumentError.notNull('tripIdentifier');
    }

    return '${_config.beRightThereAuthority}/trip/${tripIdentifier.identifier}';
  }
}
