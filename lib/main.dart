import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart' as io_client;
import 'package:provider/provider.dart';

import 'package:berightthere_client/config.dart';
import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/screens/be_right_there_app.dart';
import 'package:berightthere_client/provider/trip_provider.dart';

Future<Config> _loadConfig() async {
  return await rootBundle.loadStructuredData('config.json', (String s) async {
    return Config.fromJson(json.decode(s));
  });
}

void main() async {
  var config = await _loadConfig();
  var tripProvider = TripProvider(io_client.IOClient(), config);

  runApp(ChangeNotifierProvider(
      builder: (context) => TripModel(), child: BeRightThereApp(tripProvider)));
}
