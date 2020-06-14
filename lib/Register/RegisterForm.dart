import 'package:app/Register/Bloc/RegisterBloc.dart';
import 'package:app/Register/Bloc/RegisterEvent.dart';
import 'package:app/Register/Bloc/RegisterState.dart';
import 'package:app/Register/style.dart';
import 'package:app/bloc/AuthenticationBloc.dart';
import 'package:app/bloc/AuthenticationEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'RegisterButton.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  RegisterStyle style = RegisterStyle();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _phoneController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _phoneController.addListener(_onPhoneChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          Navigator.of(context).pop();
        } else if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Form(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Sign up with",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: style.textStyleFormField,
                  controller: _phoneController,
                  decoration: style.inputDecoration(
                      labelText: 'Phone', icon: Icons.phone),
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  autovalidate: true,
                  validator: (_) {
                    return !state.isPhoneValid ? 'Invalid Phone' : null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  controller: _passwordController,
                  decoration: style.inputDecoration(
                      labelText: 'Password', icon: Icons.lock),
                  obscureText: RegisterStyle.isObscure,
                  autocorrect: false,
                  autovalidate: true,
                  validator: (_) {
                    return !state.isPasswordValid ? 'Invalid Password' : null;
                  },
                ),
                SizedBox(height: 20),
                RegisterButton(
                  onPressed:
                      isRegisterButtonEnabled(state) ? _onFormSubmitted : null,
                ),
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
    _registerBloc.add(
      RegisterPhoneChanged(phone: _phoneController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
          phone: _phoneController.text, password: _passwordController.text),
    );
  }
}
