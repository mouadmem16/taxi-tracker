import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPhoneChanged extends RegisterEvent {
  final String phone;

  const RegisterPhoneChanged({@required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() => 'PhoneChanged { phone :$phone }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class RegisterSubmitted extends RegisterEvent {
  final String phone;
  final String password;


  const RegisterSubmitted({
    @required this.phone,
    @required this.password,
  });

  @override
  List<Object> get props => [phone, password];

  @override
  String toString() {
    return 'Submitted { phone: $phone, password: $password }';
  }
}