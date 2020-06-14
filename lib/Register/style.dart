import 'package:app/Screens/general_style.dart';
import 'package:flutter/material.dart';

class RegisterStyle extends GeneralStyle{

// toggling between eyes in the password
  static bool isObscure = false;

// styling the TextFormField
  InputDecoration inputDecoration({String labelText, IconData icon}) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        prefixIcon: Icon(icon, color: colorScheme[2]),
        labelText: labelText,
        suffixIcon: (icon != Icons.lock)
            ? null
            : StatefulBuilder(
                builder: (_, setState) {
                  if (isObscure == false)
                    return IconButton(
                      icon: Icon(Icons.visibility, color: colorScheme[2]),
                      onPressed: () => setState(() => isObscure = !isObscure),
                    );
                  return IconButton(
                    icon: Icon(Icons.visibility_off, color: colorScheme[2]),
                    onPressed: () => setState(() => isObscure = !isObscure),
                  );
                },
              ),
        errorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)));
  }

// styling the text inside the field text
  TextStyle textStyleFormField = TextStyle(
      fontSize: 17.0, fontWeight: FontWeight.w500, color: Colors.black87);
}
