import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:berightthere_client/redux/actions/checkin_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';

class StartTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('startTripScreen'),
      appBar: AppBar(
        title: Text('Be right there'),
      ),
      body: Center(
        child: Text('Ready to start trip', key: Key('startTripText')),
      ),
      floatingActionButton: new StoreConnector<AppState, VoidCallback>(
        converter: (store) {
          return () => store.dispatch(CheckInAction());
        },
        builder: (context, callback) {
          return new FloatingActionButton(
            key: Key('startTripButton'),
            onPressed: callback,
            tooltip: 'Start trip',
            child: Icon(Icons.location_on),
          );
        },
      ),
    );
  }
}
