import 'package:flutter/material.dart';

import 'package:berightthere_client/checkin.dart';
import 'package:berightthere_client/service/trip_service.dart';

class StartTripState extends State<StartTrip> {
  TripService _tripService;

  StartTripState(this._tripService);

  void _handleStartPressed() {
    var tripIdentifier = _tripService.checkin();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Checkin(tripIdentifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be right there"),
      ),
      body: Center(
        child: Text(
          'Ready to start trip!',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleStartPressed,
        tooltip: 'Start trip',
        child: Icon(Icons.location_on),
      ),
    );
  }
}

class StartTrip extends StatefulWidget {
  final TripService _tripService;

  StartTrip(this._tripService);

  @override
  State createState() => StartTripState(_tripService);
}
