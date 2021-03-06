import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/share_provider.dart';
import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/screens/loading.dart';
import 'package:berightthere_client/screens/sharing_trip.dart';
import 'package:berightthere_client/screens/start_trip.dart';

class BeRightThereApp extends StatelessWidget {
  final TripProvider _tripProvider;
  final ShareProvider _shareProvider;

  final Store<AppState> _store;

  BeRightThereApp(this._tripProvider, this._shareProvider, this._store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: _store,
        child: MaterialApp(
            title: 'Be right there',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: buildBody,
            )));
  }

  Widget buildBody(context, state) {
    if (state.isLoading) {
      return Loading();
    } else if (state.tripIdentifier != null) {
      return SharingTrip(_tripProvider, _shareProvider);
    } else {
      return StartTrip();
    }
  }
}
