import 'package:app/Screens/general_style.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  GeneralStyle style = GeneralStyle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.colorScheme[0],
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Image.asset('assets/images/tripx_logo.png', height: 200),
        ),
      ),
    );
  }
}
