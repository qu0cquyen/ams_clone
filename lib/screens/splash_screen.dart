import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("This is Splash Screen"),
              SizedBox(
                height: 20.0,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
