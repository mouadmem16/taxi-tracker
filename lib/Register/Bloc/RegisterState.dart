import 'package:meta/meta.dart';


@immutable
class RegisterState {
  final bool isPhoneValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isPhoneValid && isPasswordValid;

  RegisterState({
    @required this.isPhoneValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory RegisterState.initial() {
    return RegisterState(
      isPhoneValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isPhoneValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isPhoneValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isPhoneValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  RegisterState update({
    bool isPhoneValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isPhoneValid: isPhoneValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool isPhoneValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegisterState(
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isPhoneValid: $isPhoneValid,
      isPasswordValid: $isPasswordValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}