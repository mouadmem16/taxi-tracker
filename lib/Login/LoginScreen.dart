import 'package:app/Login/Bloc/LoginBloc.dart';
import 'package:app/Login/LoginForm.dart';
import 'package:app/Login/style.dart';
import 'package:app/Repositories/UserRepository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginStyle style = LoginStyle();
  final UserRepository _userRepository;
  final String _firebaseToken;

  LoginScreen(
      {Key key,
      @required UserRepository userRepository,
      @required String firebaseToken})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _firebaseToken = firebaseToken,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.colorScheme[0],
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: style.colorScheme[0],
        centerTitle: true,
        elevation: 0.0,
        leading: null,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            userRepository: _userRepository, firebaseToken: _firebaseToken),
        child: Container(
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: style.colorScheme[3]),
            child: LoginForm(
                userRepository: _userRepository,
                firebaseToken: _firebaseToken)),
      ),
    );
  }
}
