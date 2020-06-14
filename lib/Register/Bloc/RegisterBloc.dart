import 'dart:async';

import 'package:app/Register/Bloc/RegisterEvent.dart';
import 'package:app/Register/Bloc/RegisterState.dart';
import 'package:app/Repositories/UserRepository.dart';
import 'package:app/Utilities/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final String _firebaseToken;

  RegisterBloc({@required UserRepository userRepository,@required String firebaseToken})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _firebaseToken = firebaseToken;

  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterPhoneChanged &&
          event is! RegisterPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterPhoneChanged ||
          event is RegisterPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterPhoneChanged) {
      yield* _mapRegisterPhoneChangedToState(event.phone);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangedToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event.phone, event.password);
    }
  }

  Stream<RegisterState> _mapRegisterPhoneChangedToState(String phone) async* {
    yield state.update(
      isPhoneValid: Validators.isValidPhone(phone),
    );
  }

  Stream<RegisterState> _mapRegisterPasswordChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    String phone,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        phone: phone,
        password: password,
        firebaseToken: _firebaseToken,
      );
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
