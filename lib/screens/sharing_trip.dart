import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:berightthere_client/providers/share_provider.dart';
import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class SharingTrip extends StatelessWidget {
  final TripProvider _tripProvider;
  final ShareProvider _shareProvider;

  SharingTrip(this._tripProvider, this._shareProvider);

  void handleShareTrip(TripIdentifier tripIdentifier) {
    final tripUrl = _tripProvider.getTripUrl(tripIdentifier);

    _shareProvider.share("I'm on my way! Follow my location at: $tripUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('sharingTripScreen'),
      appBar: AppBar(
        title: Text('Be right there'),
      ),
      body: Center(
        child: StoreConnector<AppState, List<Location>>(
          converter: (store) => store.state.locations,
          builder: (context, locations) {
            return Text('Currently shared ${locations.length} location changes',
                key: Key('sharingTripText'));
          },
        ),
      ),
      floatingActionButton: StoreConnector<AppState, TripIdentifier>(
        converter: (store) {
          return store.state.tripIdentifier;
        },
        builder: (context, tripIdentifier) {
          return new FloatingActionButton(
            key: Key('shareTripButton'),
            onPressed: () => handleShareTrip(tripIdentifier),
            tooltip: 'Share trip',
            child: Icon(Icons.share),
          );
        },
      ),
    );
  }
}
