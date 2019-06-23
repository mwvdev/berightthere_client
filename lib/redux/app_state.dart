import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/handled_location.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class AppState {
  final TripIdentifier tripIdentifier;

  final bool isLoading;

  final List<Location> incomingLocations;

  final List<HandledLocation> handledLocations;

  AppState(
      {this.tripIdentifier,
      this.incomingLocations = const [],
      this.handledLocations = const [],
      this.isLoading = false});
}
