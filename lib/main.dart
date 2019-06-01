import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart' as io_client;
import 'package:provider/provider.dart';

import 'package:berightthere_client/config_loader.dart';
import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/screens/be_right_there_app.dart';
import 'package:berightthere_client/provider/trip_provider.dart';

void main() async {
  var config = await ConfigLoader().load(rootBundle);
  var tripProvider = TripProvider(io_client.IOClient(), config);

  runApp(ChangeNotifierProvider(
      builder: (context) => TripModel(), child: BeRightThereApp(tripProvider)));
}
