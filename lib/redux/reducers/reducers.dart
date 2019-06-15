import 'package:redux/redux.dart';

import 'package:berightthere_client/redux/actions/checkin_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
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

var tripIdentifierReducer =
    TypedReducer<TripIdentifier, CheckInSucceededAction>(
        checkInSucceededReducer);

var isLoadingReducer = combineReducers<bool>([
  TypedReducer<bool, CheckInLoadingAction>(checkInLoadingReducer),
  TypedReducer<bool, LocationSubscriptionAction>(locationSubscriptionReducer)
]);

var locationsReducer =
    TypedReducer<List<Location>, LocationChangedAction>(locationChangedReducer);

AppState appStateReducer(AppState state, action) {
  return new AppState(
      tripIdentifier: tripIdentifierReducer(state.tripIdentifier, action),
      isLoading: isLoadingReducer(state.isLoading, action),
      locations: locationsReducer(state.locations, action));
}
