import 'package:redux/redux.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/actions/trip_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/reducers/reducers.dart';
import 'package:berightthere_client/redux/report_status.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

main() {
  Store<AppState> store;

  setUp(() {
    store = Store<AppState>(appStateReducer, initialState: AppState());
  });

  List<Location> createLocations() {
    return [
      Location(55.6739062, 12.5556993),
      Location(55.6746322, 12.5585318),
      Location(55.6764229, 12.5588751)
    ];
  }

  Store<AppState> createStore(AppState appState) {
    return Store<AppState>(appStateReducer, initialState: appState);
  }

  test('sets isLoading to true when check-in loading', () {
    store.dispatch(CheckInLoadingAction());

    expect(store.state.isLoading, isTrue);
  });

  test('sets isLoading to false when subscribing for location changes', () {
    store.dispatch(LocationSubscriptionAction());

    expect(store.state.isLoading, isFalse);
  });

  test('adds location to incoming locations when location changed', () {
    final location = Location(55.6739062, 12.5556993);

    store.dispatch(LocationChangedAction(location));

    expect(store.state.incomingLocations, contains(location));
  });

  test('moves location when report location succeeded', () {
    var locations = createLocations();
    var expectedIncomingLocations = locations.getRange(1, locations.length);

    var store = createStore(AppState(incomingLocations: locations));

    store.dispatch(ReportLocationSucceededAction(locations.first));

    expect(
        store.state.incomingLocations, equals(expectedIncomingLocations));

    expect(store.state.handledLocations, isNotEmpty);
    var handledLocation = store.state.handledLocations.single;
    expect(handledLocation.location, equals(locations.first));
    expect(handledLocation.reportStatus, equals(ReportStatus.Success));
  });

  test('moves location when report location failed', () {
    var locations = createLocations();
    var expectedIncomingLocations = locations.getRange(1, locations.length);

    var store = createStore(AppState(incomingLocations: locations));

    store.dispatch(ReportLocationFailedAction(locations.first));

    expect(
        store.state.incomingLocations, equals(expectedIncomingLocations));

    expect(store.state.handledLocations, isNotEmpty);
    var handledLocation = store.state.handledLocations.single;
    expect(handledLocation.location, equals(locations.first));
    expect(handledLocation.reportStatus, equals(ReportStatus.Failure));
  });

  test('sets trip identifier when check-in succeeded', () {
    final tripIdentifier = TripIdentifier('identifier');

    store.dispatch(CheckInSucceededAction(tripIdentifier));

    expect(store.state.tripIdentifier, equals(tripIdentifier));
  });
}
