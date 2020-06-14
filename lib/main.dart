import 'package:app/Login/LoginScreen.dart';
import 'package:app/Map/MapScreen.dart';
import 'package:app/Screens/MapScreen.dart';
import 'package:app/Utilities/AppLocalizations.dart';
import 'package:app/Utilities/PushNotificationsManager.dart';
import 'package:app/bloc/AuthenticationBloc.dart';
import 'package:app/bloc/AuthenticationEvents.dart';
import 'package:app/bloc/AuthenticationState.dart';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'Repositories/UserRepository.dart';

import 'Screens/SplashScreen.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

PushNotificationsManager notification;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  notification = new PushNotificationsManager();
  notification.init();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'JO'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print("start");
          print(notification.token);
          if (state is AuthenticationFailure) {
            return LoginScreen(
              userRepository: _userRepository,
              firebaseToken: notification.token,
            );
          }
          if (state is AuthenticationSuccess) {
            return MapPage();
          }
          return SplashScreen();
          return MapScreen();
        },
      ),
    );
  }
}
