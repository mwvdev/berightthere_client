import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/model/trip_identifier.dart';

class TripProvider {
  final http.Client _client;
  final Config _config;

  TripProvider(this._client, this._config);

  Future<TripIdentifier> checkIn() async {
    final response = await _client.get('${_config.apiEndpoint}/trip/checkin');

    if (response.statusCode == 200) {
      return TripIdentifier.fromJson(json.decode(response.body));
    } else {
      throw CheckInException(
          'Failed to checkin. Reason: ${response.reasonPhrase}');
    }
  }
}

class CheckInException implements Exception {
  final String _message;

  CheckInException(this._message);

  String get message => _message;
}
