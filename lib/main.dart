import 'package:ams/blocs/blocs.dart';
import 'package:ams/repositories/auth/auth_repository.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:ams/screens/screens.dart';
import 'package:ams/util/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = AuthBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AppStarted()),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            homeRepository: HomeRepository(),
          ),
        ),
        BlocProvider<QrScanBloc>(
          create: (_) => QrScanBloc(
            transactionRepository: TransactionRepository(),
          ),
        ),
        BlocProvider<OnBoardingBloc>(
          create: (_) => OnBoardingBloc(ticker: Ticker()),
        ),
        BlocProvider<PaymentBloc>(
          create: (_) => PaymentBloc(
            transactionRepository: TransactionRepository(),
          )..add(PaymentPageStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo AMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PaymentScreen(),
      ),
    );
  }
}
