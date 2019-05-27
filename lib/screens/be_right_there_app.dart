import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:berightthere_client/model/trip_model.dart';
import 'package:berightthere_client/provider/trip_provider.dart';
import 'package:berightthere_client/screens/start_trip.dart';
import 'package:berightthere_client/screens/track_location.dart';

class BeRightThereApp extends StatelessWidget {
  final TripProvider _tripProvider;

  BeRightThereApp(this._tripProvider);

  bool isCheckedIn(TripModel tripModel) {
    return tripModel.tripIdentifier != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be right there',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<TripModel>(builder: (context, tripModel, child) {
        return tripModel.tripState == TripState.checkedIn
            ? TrackLocation(tripModel.tripIdentifier)
            : StartTrip(_tripProvider);
      }),
    );
  }
}
