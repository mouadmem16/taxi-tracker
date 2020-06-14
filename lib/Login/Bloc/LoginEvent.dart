import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginPhoneChanged extends LoginEvent {
  final String phone;

  const LoginPhoneChanged({@required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() => 'PhoneChanged { phone :$phone }';
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String phone;
  final String password;
  final String firebaseToken;

  const LoginWithCredentialsPressed({
    @required this.phone,
    @required this.password,
    @required this.firebaseToken,
  });

  @override
  List<Object> get props => [phone, password, firebaseToken];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { phone: $phone, password: $password, firebaseToken: $firebaseToken }';
  }
}
