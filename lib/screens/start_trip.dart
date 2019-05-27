import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/provider/trip_provider.dart';

class StartTrip extends StatelessWidget {
  final TripProvider _tripProvider;

  StartTrip(this._tripProvider);

  void _handleStartPressed(BuildContext context) {
    var tripModel = Provider.of<TripModel>(context, listen: false);

    var tripIdentifierFuture = _tripProvider.checkIn();

    tripIdentifierFuture.then((tripIdentifier) {
      tripModel.tripIdentifier = tripIdentifier;
      tripModel.tripState = TripState.checkedIn;
    }).catchError((_) => tripModel.tripState = TripState.checkInFailed);

    tripModel.tripState = TripState.checkingIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be right there"),
      ),
      body: Center(
        child: Consumer<TripModel>(builder: (context, tripModel, child) {
          switch (tripModel.tripState) {
            case TripState.ready:
              return Text(
                'Ready to start trip!',
                key: Key('startTripText'),
              );
            case TripState.checkingIn:
              return CircularProgressIndicator(key: Key('progressIndicator'));
            case TripState.checkedIn:
              return Text('Check-in successful!', key: Key('successText'));
            case TripState.checkInFailed:
              return Text('Check-in failed. Please try again later.',
                  key: Key('failureText'));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
          key: Key('startTripButton'),
          onPressed: () => _handleStartPressed(context),
          tooltip: 'Start trip',
          child: Icon(Icons.location_on)),
    );
  }
}
