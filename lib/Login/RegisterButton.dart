import 'package:app/Login/style.dart';
import 'package:app/Register/RegisterScreen.dart';
import 'package:app/Repositories/UserRepository.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  LoginStyle style = LoginStyle();
  final UserRepository _userRepository;
  final String _firebaseToken;

  RegisterButton(
      {Key key,
      @required UserRepository userRepository,
      @required String firebaseToken})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _firebaseToken = firebaseToken,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen(
              userRepository: _userRepository,
              firebaseToken: _firebaseToken,
            );
          }),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "need an account? ",
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
          Text(
            'Sign up',
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: style.colorScheme[1]),
          ),
        ],
      ),
    );
  }
}
