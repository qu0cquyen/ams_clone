import 'package:ams/blocs/blocs.dart';
import 'package:ams/repositories/home/home_repository.dart';
import 'package:ams/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameTextBoxController =
      new TextEditingController();
  final TextEditingController _passwordTextBoxController =
      new TextEditingController();

  @override
  void dispose() {
    _userNameTextBoxController.dispose();
    _passwordTextBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
          if (state.isSuccess) {
            Navigator.of(context).pop();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => BlocProvider<HomeBloc>(
            //       create: (_) => HomeBloc(
            //         homeRepository: HomeRepository(),
            //       )..add(HomeStarted()),
            //       child: HomeScreen(),
            //     ),
            //   ),
            // );
          } else if (state.isFailure) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.errorMessage),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  );
                });
          }
        }, builder: (context, state) {
          return _bodyBuilder(state);
        }),
      ),
    );
  }

  Stack _bodyBuilder(LoginState state) {
    return Stack(
      children: <Widget>[
        _buildForm(state),
        state.isSubmitting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  ListView _buildForm(LoginState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      children: <Widget>[
        TextFormField(
          controller: _userNameTextBoxController,
          decoration: InputDecoration(
            hintText: 'Username',
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(Icons.person),
          ),
          autovalidate: true,
          validator: (_) => !state.isUsernameValid &&
                  _userNameTextBoxController.text.isNotEmpty
              ? 'Invalid Username'
              : null,
          onChanged: (val) =>
              context.bloc<LoginBloc>().add(UsernameChanged(username: val)),
        ),
        const SizedBox(height: 40.0),
        TextFormField(
          controller: _passwordTextBoxController,
          decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(Icons.lock_open),
          ),
          obscureText: true,
          autovalidate: true,
          validator: (_) => !state.isPasswordValid &&
                  _passwordTextBoxController.text.isNotEmpty
              ? 'Invalid password'
              : null,
          onChanged: (val) =>
              context.bloc<LoginBloc>().add(PasswordChanged(password: val)),
        ),
        FlatButton(
          padding: const EdgeInsets.all(12.0),
          color: Colors.black,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: state.isFormValid
              ? () => context.bloc<LoginBloc>().add(LoginPressed(
                    username: _userNameTextBoxController.text,
                    password: _passwordTextBoxController.text,
                  ))
              : null,
          child: Text('Login'),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }
}
