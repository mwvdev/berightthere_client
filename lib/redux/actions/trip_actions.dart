import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class CheckInAction {}

class CheckInLoadingAction {}

class CheckInSucceededAction {
  final TripIdentifier tripIdentifier;

  CheckInSucceededAction(this.tripIdentifier);
}

class CheckInFailedAction {
  final Object error;

  CheckInFailedAction(this.error);
}

class ReportLocationAction {
  final Location location;

  ReportLocationAction(this.location);
}

class ReportLocationSucceededAction {
  final Location location;

  ReportLocationSucceededAction(this.location);
}

class ReportLocationFailedAction {
  final Location location;

  ReportLocationFailedAction(this.location);
}
