import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/providers/location_provider.dart';
import 'package:berightthere_client/redux/actions/checkin_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/middleware/location_middleware.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class MockLocationProvider extends Mock implements LocationProvider {}

class MockStore extends Mock implements Store<AppState> {}

main() {
  MockLocationProvider mockLocationProvider;
  LocationMiddleware locationMiddleware;

  MockStore mockStore;

  setUp(() {
    mockLocationProvider = MockLocationProvider();
    locationMiddleware = LocationMiddleware(mockLocationProvider);

    mockStore = MockStore();
  });

  test('should dispatch location subscription action on check-in success', () {
    final tripIdentifier = TripIdentifier('identifier');

    locationMiddleware.call(
        mockStore, CheckInSucceededAction(tripIdentifier), (action) => {});

    verify(mockStore.dispatch(const TypeMatcher<LocationSubscriptionAction>()));
  });

  test('should dispatch location changed action on location change', () {
    final location = Location(55.6739062, 12.5556993);

    locationMiddleware.call(
        mockStore, LocationSubscriptionAction(), (action) => {});

    var locationCallback =
        verify(mockLocationProvider.subscribe(captureAny)).captured.single;
    locationCallback(location);

    var locationChangedAction = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<LocationChangedAction>())))
        .captured
        .single;

    expect(locationChangedAction.currentLocation, equals(location));
  });

  test('should unsubscribe from location provider on unsubscribe action', () {
    locationMiddleware.call(
        mockStore, LocationUnsubscriptionAction(), (action) => {});

    verify(mockLocationProvider.unsubscribe());
  });
}
