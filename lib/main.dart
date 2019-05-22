import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart' as io_client;

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/service/trip_service.dart';
import 'package:berightthere_client/start_trip.dart';

Future<Config> _loadConfig() async {
  return await rootBundle.loadStructuredData('config.json', (String s) async {
    return Config.fromJson(json.decode(s));
  });
}

void main() async {
  var config = await _loadConfig();
  var tripService = TripService(new io_client.IOClient(), config);

  runApp(BeRightThereApp(tripService));
}

class BeRightThereApp extends StatelessWidget {
  final TripService _tripService;

  BeRightThereApp(this._tripService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be right there',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartTrip(_tripService),
    );
  }
}
