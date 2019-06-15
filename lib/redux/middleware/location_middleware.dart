import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/location_provider.dart';
import 'package:berightthere_client/redux/actions/checkin_actions.dart';
import 'package:berightthere_client/redux/actions/location_actions.dart';
import 'package:berightthere_client/redux/app_state.dart';
import 'package:berightthere_client/redux/location.dart';

class LocationMiddleware implements MiddlewareClass<AppState> {
  final LocationProvider _locationProvider;

  LocationMiddleware(this._locationProvider);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is LocationSubscriptionAction) {
      _locationProvider
          .subscribe((location) => _locationChangedCallback(store, location));
    } else if (action is LocationUnsubscriptionAction) {
      _locationProvider.unsubscribe();
    } else if (action is CheckInSucceededAction) {
      store.dispatch(LocationSubscriptionAction());
    }

    next(action);
  }

  _locationChangedCallback(Store<AppState> store, Location location) {
    store.dispatch(LocationChangedAction(location));
  }
}
