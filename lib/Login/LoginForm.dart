import 'package:app/Login/Bloc/LoginBloc.dart';
import 'package:app/Login/Bloc/LoginEvent.dart';
import 'package:app/Login/Bloc/LoginState.dart';
import 'package:app/Login/LoginButton.dart';
import 'package:app/Login/RegisterButton.dart';
import 'package:app/Login/style.dart';
import 'package:app/Repositories/UserRepository.dart';
import 'package:app/bloc/AuthenticationBloc.dart';
import 'package:app/bloc/AuthenticationEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  final String _firebaseToken;

  LoginForm(
      {Key key,
      @required UserRepository userRepository,
      @required String firebaseToken})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _firebaseToken = firebaseToken,
        super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginStyle style = LoginStyle();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  String get _firebaseToken => widget._firebaseToken;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _phoneController.addListener(_onPhoneChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  bool get isPopulated =>
      _phoneController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: style.inputDecoration(
                      icon: Icons.phone, labelText: "Phone"),
                  keyboardType: TextInputType.phone,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isPhoneValid ? 'Invalid Phone' : null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: style.inputDecoration(
                      icon: Icons.lock, labelText: "Password"),
                  obscureText: LoginStyle.isObscure,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isPasswordValid ? 'Invalid Password' : null;
                  },
                ),
                SizedBox(height: 20),
                LoginButton(
                  onPressed:
                      isLoginButtonEnabled(state) ? _onFormSubmitted : null,
                ),
                SizedBox(height: 10),
                RegisterButton(
                  userRepository: _userRepository,
                  firebaseToken: _firebaseToken,
                ),
//                        GoogleLoginButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    _loginBloc.add(
      LoginPhoneChanged(phone: _phoneController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
          phone: _phoneController.text,
          password: _passwordController.text,
          firebaseToken: _firebaseToken),
    );
  }
}
