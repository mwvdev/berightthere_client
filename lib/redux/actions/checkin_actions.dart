import 'package:berightthere_client/redux/trip_identifier.dart';

class CheckInAction {}

class CheckInLoadingAction {}

class CheckInSucceededAction {
  TripIdentifier tripIdentifier;

  CheckInSucceededAction(this.tripIdentifier);
}

class CheckInFailedAction {
  Object error;

  CheckInFailedAction(this.error);
}
