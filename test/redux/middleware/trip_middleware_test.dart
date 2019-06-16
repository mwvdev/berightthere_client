import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/actions/checkin_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/middleware/trip_middleware.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class MockTripProvider extends Mock implements TripProvider {}

class MockStore extends Mock implements Store<AppState> {}

main() {
  TripMiddleware tripMiddleware;
  MockTripProvider mockTripProvider;

  MockStore mockStore;

  setUp(() {
    mockTripProvider = MockTripProvider();
    tripMiddleware = TripMiddleware(mockTripProvider);

    mockStore = MockStore();
  });

  test('should dispatch CheckInLoadingAction while checking in', () {
    final tripIdentifier = TripIdentifier('identifier');

    when(mockTripProvider.checkIn())
        .thenAnswer((_) => Future.value(tripIdentifier));

    tripMiddleware.call(mockStore, CheckInAction(), (action) => {});

    verify(mockStore.dispatch(TypeMatcher<CheckInLoadingAction>()));
  });

  test('should dispatch CheckInSucceededAction when check-in succeeds',
      () async {
    final tripIdentifier = TripIdentifier('identifier');

    when(mockTripProvider.checkIn())
        .thenAnswer((_) => Future.value(tripIdentifier));

    tripMiddleware.call(mockStore, CheckInAction(), (action) => {});

    await untilCalled(
        mockStore.dispatch(const TypeMatcher<CheckInSucceededAction>()));
    var checkInSucceededAction = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<CheckInSucceededAction>())))
        .captured
        .single;

    expect(checkInSucceededAction.tripIdentifier, equals(tripIdentifier));
  });

  test('should dispatch CheckInFailedAction when check-in fails', () async {
    final error = 'Expected error';

    when(mockTripProvider.checkIn()).thenAnswer((_) => Future.error(error));

    tripMiddleware.call(mockStore, CheckInAction(), (action) => {});

    await untilCalled(
        mockStore.dispatch(const TypeMatcher<CheckInFailedAction>()));
    var checkInFailedAction = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<CheckInFailedAction>())))
        .captured
        .single;

    expect(checkInFailedAction.error, equals(error));
  });

  test('should addLocation when location changed', () async {
    final tripIdentifier = TripIdentifier('identifier');
    final location = Location(55.6739062, 12.5556993);

    var appState = AppState(tripIdentifier: tripIdentifier);
    when(mockStore.state).thenReturn(appState);

    when(mockTripProvider.addLocation(tripIdentifier, location))
        .thenAnswer((_) => Future.value());

    tripMiddleware.call(
        mockStore, LocationChangedAction(location), (action) => {});

    verify(mockTripProvider.addLocation(tripIdentifier, location));
  });

  test('should ignore errors occuring when adding location', () async {
    final tripIdentifier = TripIdentifier('identifier');
    final location = Location(55.6739062, 12.5556993);

    var appState = AppState(tripIdentifier: tripIdentifier);
    when(mockStore.state).thenReturn(appState);

    when(mockTripProvider.addLocation(tripIdentifier, location))
        .thenAnswer((_) => Future.error('Error'));

    tripMiddleware.call(
        mockStore, LocationChangedAction(location), (action) => {});

    verify(mockTripProvider.addLocation(tripIdentifier, location));
  });
}
