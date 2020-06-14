import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {

  getString(key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  setString(key, val) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, val);
  }

  isLoggedIn() async {
    var token = this.getString('user_info');
    if (token != null || token != '') {
      return true;
    }
    return true;
  }

  Future<String> getAccessToken() async {
    JsonCodec codec = new JsonCodec();
    final prefs = await SharedPreferences.getInstance();
    var tokenLoad = prefs.getString('user_token');
    if (tokenLoad != null && tokenLoad != '') {
      var token = codec.decode(tokenLoad);
      return token['access_token'];
    }
    return '';
  }
}
