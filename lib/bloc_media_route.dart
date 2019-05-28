import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_google_cast_button/flutter_google_cast_button.dart';

const _STATE_UNAVAILABLE = 1;
const _STATE_UNCONNECTED = 2;
const _STATE_CONNECTING = 3;
const _STATE_CONNECTED = 4;

class MediaRouteBloc extends Bloc<MediaRouteEvent, MediaRouteState> {
  var debugMode = false;

  MediaRouteBloc() {
    FlutterGoogleCastButton.castEventStream().listen(
      (event) {
        _printD("MediaRouteBloc listen state changed: $event");
        if (event is int) {
          dispatch(UpdateRouteStateEvent(event));
        }
      },
      onError: (e) {
        dispatch(UpdateRouteStateEvent(1));
      },
    );
  }

  @override
  MediaRouteState get initialState => NoDeviceAvailable();

  @override
  Stream<MediaRouteState> mapEventToState(MediaRouteEvent event) async* {
    if (event is UpdateRouteStateEvent) {
      switch (event.nativeState) {
        case _STATE_UNCONNECTED:
          yield Unconnected();
          break;
        case _STATE_CONNECTING:
          yield Connecting();
          break;
        case _STATE_CONNECTED:
          yield Connected();
          break;
        case _STATE_UNAVAILABLE:
        default:
          yield NoDeviceAvailable();
      }
    }
  }

  _printD(String message) {
    if (debugMode) {
      print(message);
    }
  }
}

class MediaRouteState extends Equatable {}

class NoDeviceAvailable extends MediaRouteState {}

class Unconnected extends MediaRouteState {}

class Connected extends MediaRouteState {}

class Connecting extends MediaRouteState {}

class MediaRouteEvent extends Equatable {}

class UpdateRouteStateEvent extends MediaRouteEvent {
  int nativeState;

  UpdateRouteStateEvent(int newState) {
    nativeState = newState;
  }
}
