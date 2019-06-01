import 'package:flutter/foundation.dart';

import 'package:berightthere_client/model/trip_identifier.dart';

class TripModel extends ChangeNotifier {
  TripState _tripState = TripState.ready;
  TripIdentifier _tripIdentifier;

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
}

enum TripState {
  ready,
  checkingIn,
  checkedIn,
  checkInFailed,
}
