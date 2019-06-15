import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class AppState {
  final TripIdentifier tripIdentifier;

  final bool isLoading;

  final List<Location> locations;

  AppState(
      {this.tripIdentifier, this.locations = const [], this.isLoading = false});
}
