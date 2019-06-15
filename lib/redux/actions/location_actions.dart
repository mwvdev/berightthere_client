import 'package:berightthere_client/redux/location.dart';

class LocationSubscriptionAction {}

class LocationChangedAction {
  Location currentLocation;

  LocationChangedAction(this.currentLocation);
}

class LocationUnsubscriptionAction {}
