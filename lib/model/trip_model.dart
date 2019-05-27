import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:berightthere_client/model/trip_identifier.dart';

class TripModel extends ChangeNotifier {
  TripState _tripState = TripState.ready;
  TripIdentifier _tripIdentifier;
  final List<Location> _locations = [];

  TripState get tripState => _tripState;

  set tripState(TripState value) {
    _tripState = value;
    notifyListeners();
  }

  TripIdentifier get tripIdentifier => _tripIdentifier;

  set tripIdentifier(TripIdentifier value) {
    _tripIdentifier = value;
    notifyListeners();
  }

  UnmodifiableListView<Location> get locations =>
      UnmodifiableListView(_locations);

  void addLocation(Location item) {
    _locations.add(item);
    notifyListeners();
  }
}

enum TripState {
  ready,
  checkingIn,
  checkedIn,
  checkInFailed,
}

@immutable
class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}
