import 'package:redux/redux.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/redux/actions/checkin_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/reducers/reducers.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

main() {
  Store<AppState> store;

  setUp(() {
    store = Store<AppState>(appStateReducer, initialState: AppState());
  });

  test('sets isLoading to true when check-in loading', () {
    store.dispatch(CheckInLoadingAction());

    expect(store.state.isLoading, isTrue);
  });

  test('sets isLoading to false when subscribing for location changes', () {
    store.dispatch(LocationSubscriptionAction());

    expect(store.state.isLoading, isFalse);
  });

  test('adds location when location changed', () {
    final location = Location(55.6739062, 12.5556993);

    store.dispatch(LocationChangedAction(location));

    expect(store.state.locations, contains(location));
  });

  test('sets trip identifier when check-in succeeded', () {
    final tripIdentifier = TripIdentifier('identifier');

    store.dispatch(CheckInSucceededAction(tripIdentifier));

    expect(store.state.tripIdentifier, equals(tripIdentifier));
  });
}
