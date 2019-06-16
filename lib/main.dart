import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart' as io_client;
import 'package:redux/redux.dart';

import 'package:berightthere_client/config_loader.dart';
import 'package:berightthere_client/providers/location_provider.dart';
import 'package:berightthere_client/providers/share_provider.dart';
import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/middleware/location_middleware.dart';
import 'package:berightthere_client/redux/middleware/trip_middleware.dart';
import 'package:berightthere_client/redux/reducers/reducers.dart';
import 'package:berightthere_client/screens/be_right_there_app.dart';

void main() async {
  var config = await ConfigLoader().load(rootBundle);

  var tripProvider = TripProvider(io_client.IOClient(), config);
  var tripMiddleware = TripMiddleware(tripProvider);

  var locationProvider = LocationProvider(Geolocator());
  var locationMiddleware = LocationMiddleware(locationProvider);

  var shareProvider = ShareProvider();

  final store = Store<AppState>(appStateReducer,
      middleware: [tripMiddleware, locationMiddleware],
      initialState: AppState());

  runApp(BeRightThereApp(tripProvider, shareProvider, store));
}
