import 'dart:async';
import 'dart:convert';

import 'package:ams/blocs/blocs.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:ams/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScanScreen extends StatefulWidget {
  final Widget child;
  QRScanScreen({this.child});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = '';
  bool _isFlash = false;
  String qrContent;
  String transID;
  String toggleString = '';
  bool toggleFlash = true;
  Timer _timer;
  QRViewController controller;
  AnimationController animationController;
  Animation<double> verticalPosition;

  @override
  void initState() {
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );

    animationController.addListener(() {
      this.setState(() {});
    });

    animationController.forward();

    verticalPosition = Tween<double>(begin: 5.0, end: 240.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear))
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          animationController.reverse();
        } else if (state == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

    _timer = Timer.periodic(const Duration(seconds: 10),
        (timer) => setState(() => toggleFlash = !toggleFlash));
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      if (qrContent == null) {
        qrContent = scanData;
        print("QR Scanner is scanning ......");
        Map<String, dynamic> jsonTransaction = jsonDecode(qrContent);
        transID = jsonTransaction["transactionID"];
        context.bloc<QrScanBloc>().add(QrScanTransactionRequest(
            transactionID: jsonTransaction["transactionID"]));
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrScanBloc, QrScanState>(
      listener: (context, state) {
        if (state is QrScanStateFound) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<PaymentBloc>(
                  create: (_) => PaymentBloc(
                    transactionRepository: TransactionRepository(),
                  )..add(PaymentPageStarted()),
                  child: PaymentScreen(),
                ),
              ));
        }

        if (state is QrScanStateLoading) {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is QrScanStateLoaded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildScanner(),
        );
      },
    );
  }

  Widget _buildScanner() {
    // When haven't located QR Code => generate scanner
    return Stack(
      children: <Widget>[
        // Generate Scanner with the help of 3rd lib
        QRView(
          key: qrKey,
          onQRViewCreated: (r) => _onQRViewCreated(r, context),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelperScreen())),
              ),
            ],
          ),
        ),
        // Create a box stacks on top of Scanner
        // And integrate animation on the box.
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Positioned(
                    top: verticalPosition.value,
                    child: Container(
                      width: 250,
                      height: 3.0,
                      decoration:
                          BoxDecoration(color: Colors.white24, boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.redAccent,
                          spreadRadius: 3.0,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                  duration: const Duration(seconds: 3),
                  firstChild: InkWell(
                    onTap: () {
                      setState(() {
                        _isFlash = !_isFlash;
                        controller.toggleFlash();
                      });
                    },
                    child: Container(
                      width: 250,
                      child: Text(
                          "Position the merchant's QR code within the frame to check in",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  secondChild: InkWell(
                    onTap: () {
                      setState(() {
                        _isFlash = !_isFlash;
                        controller.toggleFlash();
                      });
                    },
                    child: Container(
                      width: 250,
                      child: Text(
                        "⚡ Tap to turn on flash",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  crossFadeState: toggleFlash
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildScannedCode(String transactionID) {
  //   return Center(
  //     child: Container(
  //         width: 250,
  //         height: 250,
  //         child: transactionID == null
  //             ? SizedBox.shrink()
  //             : QrImage(
  //                 data: transactionID,
  //                 version: QrVersions.auto,
  //                 size: 200,
  //                 gapless: false,
  //               )),
  //   );
  // }
}
