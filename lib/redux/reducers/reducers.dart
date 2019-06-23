import 'package:redux/redux.dart';

import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/actions/trip_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/handled_location.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/report_status.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

bool checkInLoadingReducer(bool isLoading, CheckInLoadingAction action) {
  return true;
}

bool locationSubscriptionReducer(
    bool isLoading, LocationSubscriptionAction action) {
  return false;
}

TripIdentifier checkInSucceededReducer(
    TripIdentifier tripIdentifier, CheckInSucceededAction action) {
  return action.tripIdentifier;
}

List<Location> locationChangedReducer(
    List<Location> locations, LocationChangedAction action) {
  return List.from(locations)..add(action.currentLocation);
}

List<Location> locationsSucceededReducer(
    List<Location> locations, ReportLocationSucceededAction action) {
  return List.from(locations)..remove(action.location);
}

List<Location> locationsFailedReducer(
    List<Location> locations, ReportLocationFailedAction action) {
  return List.from(locations)..remove(action.location);
}

List<HandledLocation> handledLocationsSucceededReducer(
    List<HandledLocation> handledLocations,
    ReportLocationSucceededAction action) {
  return List.from(handledLocations)
    ..add(HandledLocation(action.location, ReportStatus.Success));
}

List<HandledLocation> handledLocationsFailedReducer(
    List<HandledLocation> handledLocations, ReportLocationFailedAction action) {
  return List.from(handledLocations)
    ..add(HandledLocation(action.location, ReportStatus.Failure));
}

var tripIdentifierReducer =
    TypedReducer<TripIdentifier, CheckInSucceededAction>(
        checkInSucceededReducer);

var isLoadingReducer = combineReducers<bool>([
  TypedReducer<bool, CheckInLoadingAction>(checkInLoadingReducer),
  TypedReducer<bool, LocationSubscriptionAction>(locationSubscriptionReducer)
]);

var incomingLocationsReducer = combineReducers<List<Location>>([
  TypedReducer<List<Location>, LocationChangedAction>(locationChangedReducer),
  TypedReducer<List<Location>, ReportLocationSucceededAction>(
      locationsSucceededReducer),
  TypedReducer<List<Location>, ReportLocationFailedAction>(
      locationsFailedReducer),
]);

var handledLocationsReducer = combineReducers<List<HandledLocation>>([
  TypedReducer<List<HandledLocation>, ReportLocationSucceededAction>(
      handledLocationsSucceededReducer),
  TypedReducer<List<HandledLocation>, ReportLocationFailedAction>(
      handledLocationsFailedReducer),
]);

AppState appStateReducer(AppState state, action) {
  return new AppState(
      tripIdentifier: tripIdentifierReducer(state.tripIdentifier, action),
      isLoading: isLoadingReducer(state.isLoading, action),
      incomingLocations:
          incomingLocationsReducer(state.incomingLocations, action),
      handledLocations:
          handledLocationsReducer(state.handledLocations, action));
}
