part of 'login_bloc.dart';

@immutable
class LoginState{
  final bool isUsernameValid;
  final bool isPasswordValid; 
  final bool isSubmitting; 
  final bool isSuccess; 
  final bool isFailure;
  final String errorMessage; 

  bool get isFormValid => isUsernameValid && isPasswordValid; 

  const LoginState({
    @required this.isUsernameValid,
    @required this.isPasswordValid, 
    @required this.isSubmitting, 
    @required this.isSuccess, 
    @required this.isFailure, 
    @required this.errorMessage
  });

  factory LoginState.empty() {
    return LoginState(
      isUsernameValid: false, 
      isPasswordValid: false, 
      isSubmitting: false, 
      isSuccess: false, 
      isFailure: false,
      errorMessage: ''
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isUsernameValid: true, 
      isPasswordValid: true, 
      isSubmitting: true, 
      isSuccess: false, 
      isFailure: false, 
      errorMessage: ''
    );
  }

  factory LoginState.failure(String errorMessage){
    return LoginState(
      isUsernameValid: true, 
      isPasswordValid: true, 
      isSubmitting: false, 
      isSuccess: false, 
      isFailure: true, 
      errorMessage: errorMessage, 
    );
  }

  factory LoginState.success(){
    return LoginState(
      isUsernameValid: true, 
      isPasswordValid: true, 
      isSubmitting: false,
      isSuccess: true, 
      isFailure: false, 
      errorMessage: '',
    );
  }
  
  LoginState copyWith({
    bool isUsernameValid, 
    bool isPasswordValid, 
    bool isSubmitting, 
    bool isSuccess, 
    bool isFailure, 
    String errorMessage,
  }){
    return LoginState(
      isUsernameValid: isUsernameValid ?? this.isUsernameValid, 
      isPasswordValid: isPasswordValid ?? this.isPasswordValid, 
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isSuccess: isSuccess ?? this.isSuccess, 
      isFailure: isFailure ?? this.isFailure, 
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }


  LoginState update({
    bool isUsernameValid, 
    bool isPasswordValid,
  }){
    return copyWith(
      isUsernameValid: isUsernameValid, 
      isPasswordValid: isPasswordValid, 
      isSubmitting: false, 
      isSuccess: false, 
      isFailure: false, 
      errorMessage: '', 
    );
  }

  @override
  String toString() => '''LoginState {
    isUsernameValid: $isUsernameValid, 
    isPasswordValid: $isPasswordValid,
    isSubmitting: $isSubmitting, 
    isSuccess: $isSuccess, 
    isFailure: $isFailure, 
    errorMessage: $errorMessage
  }
  ''';
}