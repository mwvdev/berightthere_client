import 'package:flutter/material.dart';

import 'package:berightthere_client/model/trip_identifier.dart';

class Checkin extends StatelessWidget {
  final Future<TripIdentifier> _tripIdentifier;

  Checkin(this._tripIdentifier);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be right there"),
      ),
      body: Center(
        child: FutureBuilder<TripIdentifier>(
          future: _tripIdentifier,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.identifier);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
