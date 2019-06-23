import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/actions/trip_actions.dart';
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
    var action = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<CheckInFailedAction>())))
        .captured
        .single;

    expect(action.error, equals(error));
  });

  test(
      'should dispatch ReportLocationAction when location changed and incoming locations is empty',
      () async {
    final location = Location(55.6739062, 12.5556993);

    var appState = AppState();
    when(mockStore.state).thenReturn(appState);

    tripMiddleware.call(
        mockStore, LocationChangedAction(location), (action) => {});

    var action = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<ReportLocationAction>())))
        .captured
        .single;
    expect(action.location, equals(location));
  });

  test(
      'should not dispatch ReportLocationAction when location changed and incoming locations is not empty',
      () async {
    final location = Location(55.6739062, 12.5556993);

    var appState = AppState(incomingLocations: [Location(0, 0)]);
    when(mockStore.state).thenReturn(appState);

    tripMiddleware.call(
        mockStore, LocationChangedAction(location), (action) => {});

    verifyNever(mockStore.dispatch(any));
  });

  test(
      'should dispatch ReportLocationAction for next location when reporting '
      'location succeeded and incoming locations not empty', () async {
    final location1 = Location(55.6739062, 12.5556993);
    final location2 = Location(55.6746322, 12.5585318);

    var appState = AppState(incomingLocations: [location1, location2]);
    when(mockStore.state).thenReturn(appState);

    tripMiddleware.call(mockStore,
        ReportLocationSucceededAction(Location(0, 0)), (action) => {});

    var action = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<ReportLocationAction>())))
        .captured
        .single;
    expect(action.location, equals(location2));
  });

  test(
      'should dispatch ReportLocationAction for next location when reporting '
      'location failed and incoming locations not empty', () async {
    final location1 = Location(55.6739062, 12.5556993);
    final location2 = Location(55.6746322, 12.5585318);

    var appState = AppState(incomingLocations: [location1, location2]);
    when(mockStore.state).thenReturn(appState);

    tripMiddleware.call(mockStore,
        ReportLocationSucceededAction(Location(0, 0)), (action) => {});

    var action = verify(mockStore
            .dispatch(captureThat(const TypeMatcher<ReportLocationAction>())))
        .captured
        .single;
    expect(action.location, equals(location2));
  });

  test('should dispatch ReportLocationSucceededAction when reporting succeeds',
      () async {
    final tripIdentifier = TripIdentifier('identifier');
    final location = Location(55.6739062, 12.5556993);

    var appState = AppState(tripIdentifier: tripIdentifier);
    when(mockStore.state).thenReturn(appState);

    when(mockTripProvider.addLocation(tripIdentifier, location))
        .thenAnswer((_) => Future.value());

    tripMiddleware.call(
        mockStore, ReportLocationAction(location), (action) => {});

    await untilCalled(
        mockStore.dispatch(const TypeMatcher<ReportLocationSucceededAction>()));
    var action = verify(mockStore.dispatch(
            captureThat(const TypeMatcher<ReportLocationSucceededAction>())))
        .captured
        .single;
    expect(action.location, equals(location));
  });

  test('should dispatch ReportLocationFailedAction when reporting succeeds',
      () async {
    final tripIdentifier = TripIdentifier('identifier');
    final location = Location(55.6739062, 12.5556993);

    var appState = AppState(tripIdentifier: tripIdentifier);
    when(mockStore.state).thenReturn(appState);

    when(mockTripProvider.addLocation(tripIdentifier, location))
        .thenAnswer((_) => Future.error('Error'));

    tripMiddleware.call(
        mockStore, ReportLocationAction(location), (action) => {});

    await untilCalled(
        mockStore.dispatch(const TypeMatcher<ReportLocationFailedAction>()));
    var action = verify(mockStore.dispatch(
            captureThat(const TypeMatcher<ReportLocationFailedAction>())))
        .captured
        .single;
    expect(action.location, equals(location));
  });
}
