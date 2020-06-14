import 'package:app/Models/Users/UserModel.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final UserModel userModel;

  const AuthenticationSuccess(this.userModel);

  @override
  List<Object> get props => [userModel];

  @override
  String toString() => 'Authenticated { displayName: $userModel }';
}

class AuthenticationFailure extends AuthenticationState {}
