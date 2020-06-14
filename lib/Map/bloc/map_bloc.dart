import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  @override
  MapState get initialState => MapInitial();

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
