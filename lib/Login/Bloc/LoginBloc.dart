import 'dart:async';

import 'package:app/Login/Bloc/LoginEvent.dart';
import 'package:app/Login/Bloc/LoginState.dart';
import 'package:app/Repositories/UserRepository.dart';
import 'package:app/Utilities/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  final String _firebaseToken;

  LoginBloc({
    @required UserRepository userRepository,
    @required String firebaseToken,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        _firebaseToken = firebaseToken;

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! LoginPhoneChanged && event is! LoginPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is LoginPhoneChanged || event is LoginPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPhoneChanged) {
      yield* _mapLoginPhoneChangedToState(event.phone);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        phone: event.phone,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapLoginPhoneChangedToState(String phone) async* {
    yield state.update(
      isPhoneValid: Validators.isValidPhone(phone),
    );
  }

  Stream<LoginState> _mapLoginPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String phone,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      print('bloc');
      print(_firebaseToken);
      await _userRepository.signInWithCredentials(
          phone, password, _firebaseToken);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
