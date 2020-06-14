import 'dart:convert';

import 'package:app/Models/Users/TokenModel.dart';
import 'package:app/Models/Users/UserModel.dart';
import 'package:app/Utilities/ApiClient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, String> params = {
    'grant_type': 'password',
    'client_id': '2',
    'client_secret': '2CVYLTuYVL27Na12dKhgckUbZk0O2buljlibQDl1',
    'app_class': 'App\\Entities\\Users\\Customer'
  };

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    //  login(user, googleSignInAuthentication.accessToken, 'google', context);
  }

  Future<void> signInWithCredentials(
      String phone, String password, String firebaseToken) async {
    print('repo');
    print(firebaseToken);
    params.addAll(<String, String>{
      'username': phone,
      'password': password,
      'device_token': firebaseToken,
    });

    ApiClient api = new ApiClient();
    var response = await api.post('/users/v1/oauth/token', params);
    persistToken(response);
  }

  Future<void> signUp(
      {String phone, String password, String firebaseToken}) async {
    params.addAll(<String, String>{
      'username': phone,
      'password': password,
      'device_token': firebaseToken,
    });
    ApiClient api = new ApiClient();
    var response = await api.post('/users/v1/register', params);
    persistToken(response);
  }

  Future<void> signOut() async {
    return deleteToken();
  }

  Future<bool> isSignedIn() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey('user_token')) {
      TokenModel userToken =
          TokenModel.fromJson(json.decode(prefs.getString('user_token')));
      return userToken.accessToken != '';
    }
    return false;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey('user_info')) {
      return UserModel.fromJson(json.decode(prefs.getString('user_info')));
    }
    return null;
  }

  Future<void> deleteToken() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('user_token');
    prefs.remove('user_info');
  }

  Future<void> persistToken(response) async {
    if (response['data'] != null) {
      final SharedPreferences prefs = await _prefs;
      if (response['data']['token'] != null) {
        prefs.setString('user_token', json.encode(response['data']['token']));
      }
      if (response['data']['user'] != null) {
        prefs.setString('user_info', json.encode(response['data']['user']));
      }
    }
  }

  Future<bool> hasToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey('user_token');
  }
}
