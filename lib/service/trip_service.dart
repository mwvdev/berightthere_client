import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/model/trip_identifier.dart';

class TripService {
  final http.Client _client;
  final Config _config;

  TripService(this._client, this._config);

  Future<TripIdentifier> checkin() async {
    final response = await _client.get('${_config.apiEndpoint}/trip/checkin');

    if (response.statusCode == 200) {
      return TripIdentifier.fromJson(json.decode(response.body));
    } else {
      throw CheckinException(
          'Failed to checkin. Reason: ${response.reasonPhrase}');
    }
  }
}

class CheckinException implements Exception {
  final String _message;

  CheckinException(this._message);

  String get message => _message;
}
