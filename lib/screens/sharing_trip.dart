import 'package:flutter/material.dart';

import 'package:berightthere_client/redux/location.dart';

class SharingTrip extends StatelessWidget {
  final List<Location> _locations;

  SharingTrip(this._locations);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key('sharingTripScreen'),
        appBar: AppBar(
          title: Text('Be right there'),
        ),
        body: Center(
          child:
              Text('Currently shared ${_locations.length} location changes!'),
        ));
  }
}
