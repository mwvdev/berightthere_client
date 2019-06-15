import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:berightthere_client/redux/location.dart';

class LocationProvider {
  final _geolocator;
  StreamSubscription<Position> _positionStreamSubscription;

  LocationProvider(this._geolocator);

  void subscribe(Function(Location) locationChangedCallback) {
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 25);

    _positionStreamSubscription = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      locationChangedCallback(_map(position));
    });
  }

  Location _map(Position position) {
    return Location(position.latitude, position.longitude);
  }

  void unsubscribe() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
  }
}
