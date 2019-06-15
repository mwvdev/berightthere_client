import 'package:redux/redux.dart';

import 'package:berightthere_client/providers/trip_provider.dart';
import 'package:berightthere_client/redux/actions/checkin_actions.dart';
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
    }

    next(action);
  }
}
