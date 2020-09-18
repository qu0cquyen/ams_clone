part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class UsernameChanged extends LoginEvent{
  final String username; 
  
  const UsernameChanged({@required this.username});

  @override
  List<Object> get props => [username]; 

  @override
  String toString() => 'UsernameChanged {username: $username}'; 
}

class PasswordChanged extends LoginEvent{
  final String password; 

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password]; 

  @override
  String toString() => 'PasswordChanged {password: $password}'; 
}

class LoginPressed extends LoginEvent{
  final String username; 
  final String password; 

  const LoginPressed({@required this.username, this.password});

  @override
  List<Object> get props => [username, password]; 

  @override
  String toString() => 'LoginPressed {username: $username, password: $password}'; 

}

class SignupPressed extends LoginEvent {
  final String username; 
  final String password; 

  const SignupPressed({@required this.username, this.password});

  @override
  List<Object> get props => [username, password]; 

  @override
  String toString() => 'SignupPressed {username: $username, password: $password}';
}