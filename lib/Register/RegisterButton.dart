import 'package:app/Register/style.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  RegisterStyle style = RegisterStyle();
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      highlightColor: style.colorScheme[0],
      disabledColor: style.colorScheme[0].withAlpha(190),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Register', style: TextStyle(color: style.colorScheme[3]),),
    );
  }
}