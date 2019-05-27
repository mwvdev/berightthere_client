import 'package:flutter/material.dart';

import 'package:berightthere_client/model/trip_identifier.dart';

class TrackLocation extends StatelessWidget {
  final TripIdentifier _tripIdentifier;

  TrackLocation(this._tripIdentifier);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be right there"),
      ),
      body: Center(
        child: Text(_tripIdentifier.identifier),
      ),
    );
  }
}
