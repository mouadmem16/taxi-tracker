import 'package:app/Register/Bloc/RegisterBloc.dart';
import 'package:app/Register/RegisterForm.dart';
import 'package:app/Register/style.dart';
import 'package:app/Repositories/UserRepository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterStyle style = RegisterStyle();
  final UserRepository _userRepository;
  final String _firebaseToken;

  RegisterScreen(
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
        title: Text('Register'),
        backgroundColor: style.colorScheme[0],
        centerTitle: true,
        elevation: 0.0,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
              userRepository: _userRepository, firebaseToken: _firebaseToken),
          child: Container(
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: style.colorScheme[3]
            ),
            child: RegisterForm()),
        ),
      ),
    );
  }
}
