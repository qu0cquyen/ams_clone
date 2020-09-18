import 'dart:async';

import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(Unknown());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is Login) {
      yield* _mapLoginToState(event);
    } else if (event is Logout) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    print("Im in AppStarted => State()");
    try {
      User user = await _authRepository.loginWithAccessToken();
      if (user == null) {
        yield Unauthenticated();
      } else {
        yield Authenticated(user);
      }
    } catch (err) {
      print(err);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginToState(Login event) async* {
    try {
      User user = await _authRepository.loginWithUserNameAndPassword(
          username: event.username, password: event.password);

      if (user == null) yield Unauthenticated();

      yield Authenticated(user);
    } catch (err) {
      print(err);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLogoutToState() async* {
    // Delete refresh Token and Access Token
    await _authRepository.logout();
    yield Unauthenticated();
  }
}
