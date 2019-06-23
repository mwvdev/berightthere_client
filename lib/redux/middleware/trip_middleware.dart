import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/actions/trip_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/trip_identifier.dart';

class TripMiddleware implements MiddlewareClass<AppState> {
  final TripProvider _tripProvider;

  TripMiddleware(this._tripProvider);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is CheckInAction) {
      store.dispatch(CheckInLoadingAction());

      _tripProvider.checkIn().then((TripIdentifier tripIdentifier) {
        store.dispatch(CheckInSucceededAction(tripIdentifier));
      }).catchError((Object error) {
        store.dispatch(new CheckInFailedAction(error));
      });
    } else if (action is LocationChangedAction) {
      if (store.state.incomingLocations.isEmpty) {
        store.dispatch(ReportLocationAction(action.currentLocation));
      }
    } else if (action is ReportLocationAction) {
      _tripProvider
          .addLocation(store.state.tripIdentifier, action.location)
          .then((_) =>
              store.dispatch(ReportLocationSucceededAction(action.location)))
          .catchError((_) =>
              store.dispatch(ReportLocationFailedAction(action.location)));
    } else if (action is ReportLocationSucceededAction ||
        action is ReportLocationFailedAction) {
      if (store.state.incomingLocations.length > 1) {
        store.dispatch(ReportLocationAction(store.state.incomingLocations[1]));
      }
    }

    next(action);
  }
}
