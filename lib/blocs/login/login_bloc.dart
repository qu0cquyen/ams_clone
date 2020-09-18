import 'dart:async';

import 'package:ams/blocs/blocs.dart';
import 'package:ams/config/validators.dart';
import 'package:ams/models/models.dart';
import 'package:ams/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthBloc _authBloc; 
  AuthRepository _authRepository;

  LoginBloc({@required AuthBloc authBloc, @required AuthRepository authRepository}) :
        _authBloc = authBloc, 
        _authRepository = authRepository, 
        super(LoginState.empty());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async *{
    if(event is UsernameChanged){
      yield* _mapUsernameChangedToState(event); 
    } else if(event is PasswordChanged){
      yield* _mapPasswordChangedToState(event); 
    } else if(event is LoginPressed){
      yield* _mapLoginPressedToState(event); 
    }
    // } else if(event is SignupPressed){
    //   yield* _mapSignupPressedToState(event);
    // }
  }

  Stream<LoginState> _mapUsernameChangedToState(UsernameChanged event) async* {
    // Using regrex to check username validation
    yield state.update(isUsernameValid: Validators.isValidUsername(event.username));
  }

  Stream<LoginState> _mapPasswordChangedToState(PasswordChanged event) async* {
    // Apply regrex or validation method to check password
    yield state.update(isPasswordValid: Validators.isValidPassword(event.password));
  }

  Stream<LoginState> _mapLoginPressedToState(LoginPressed event) async* {
    yield LoginState.loading(); 
    try{
      //await _authRepository.loginWithUserNameAndPassword(username: event.username, password: event.password);
      _authBloc.add(Login(username: event.username, password: event.password));

      yield LoginState.success(); 

    } catch(error){
      yield LoginState.failure(error.message); 
    }
  }
}
