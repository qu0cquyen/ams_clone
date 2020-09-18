part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class Login extends AuthEvent {
  final String username; 
  final String password; 

  const Login({@required this.username, @required this.password}); 

  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'Login {username: $username, password: $password}'; 
}

class Logout extends AuthEvent {}