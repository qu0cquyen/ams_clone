import 'package:ams/blocs/blocs.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:ams/screens/home_screen/qr_scan_screen.dart';
import 'package:ams/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildHomeScreen() {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeRequest) {
        return Scaffold(
          body: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImage(
                    data: state.payment.transactionID,
                    version: QrVersions.auto,
                    size: 200,
                    gapless: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                      child: Text("Scan"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider<QrScanBloc>(
                              create: (_) => QrScanBloc(
                                transactionRepository: TransactionRepository(),
                              ),
                              child: QRScanScreen(),
                            ),
                          ),
                        );

                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => QRScanScreen()));
                      }),
                ],
              ),
            ),
          ),
        );
      }
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is Unauthenticated) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(
                  authBloc: context.bloc<AuthBloc>(),
                  authRepository: AuthRepository(),
                ),
                child: LoginScreen(),
              ),
            ),
          );
        }
      },
      builder: (context, authState) {
        print(authState.toString());
        if (authState is Unknown) {
          return SplashScreen();
        }

        if (authState is Authenticated) {
          return BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(
              homeRepository: HomeRepository(),
            )..add(HomeStarted()),
            child: _buildHomeScreen(),
          );
        }

        return Container();
        //return _buildHomeScreen();
      },
    );

    // return BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
    //   if (authState is Unknown) {
    //     return SplashScreen();
    //   }

    //   if (authState is Authenticated) {
    //     return _buildHomeScreen();
    //   }

    //   if (authState is Unauthenticated) {
    //     return BlocProvider<LoginBloc>(
    //       create: (_) => LoginBloc(
    //         authBloc: context.bloc<AuthBloc>(),
    //         authRepository: AuthRepository(),
    //       ),
    //       child: LoginScreen(),
    //     );
    //   }

    //   return Container();
    // });
    // return BlocBuilder<HomeBloc, HomeState>(
    //   builder: (BuildContext context, HomeState state) {
    //     print(state.toString());

    //     if (state is HomeRequest) {
    //       return _buildHomeScreen(state.payment.toString());
    //     }
    //     return Container();
    //     // print(state);
    //     // if (state is HomeRequest) {
    //     //   return _buildHomeScreen(state.payment.toString());
    //     // } else {
    //     //   return Container();
    //     // }
    //     // App Flow Attention needed.
    //     //return _buildHomeScreen("Transaction ID");
    //   },
    //);
  }
}
