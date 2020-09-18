part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class Unknown extends AuthState {} 

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user; 

  const Authenticated(this.user); 

  @override
  List<Object> get props => []; 

  @override
  String toString() => '''Authenticated {username: ${user.username}}''';
}

