import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ams/blocs/blocs.dart';
import 'package:ams/screens/text_screen.dart';
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
  bool _isFlash = false, _isFoundQRCode = false;
  String qrContent;
  String transID = '';
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

        context
            .bloc<QrScanBloc>()
            .add(QrScanTransactionRequest(transactionID: qrContent));
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

  Widget _buildPaymentDetaisl(QrScanStateFound scanState) {
    return Container(
      height: 250,
      color: Colors.red,
      child: Column(
        children: <Widget>[
          Text(
            scanState.transaction.username,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
            child: Divider(),
          ),
          Text(
            "Services",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "- ${scanState.transaction.services["medication"]}",
                ),
                Text("- ${scanState.transaction.services["consultant"]}"),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              context.bloc<QrScanBloc>().add(QrScanSubmitPressed(
                  transactionID: scanState.transaction.transactionID));
            },
            child: Text('Pay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrScanBloc, QrScanState>(
      listener: (context, state) {
        if (state is QrScanStateFound) {
          // Show bottom sheet
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildPaymentDetaisl(state),
          );
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

        if (state is QrScanStatePaymentSuccess) {
          int count = 0;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Payment Status'),
              content: Text('Payment has been successfully made'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).popUntil((route) {
                    return count++ == 3;
                  }),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }

        // Not test yet
        if (state is QrScanStatePaymentFailure) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Oops',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Divider(color: Colors.grey),
                    Text('Image Reserved'),
                    Text('Sorry, the QR code is not valid.'),
                    Text('Make sure you scan the correct merchant\'s QR code.'),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.black,
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(QrScanState scanState) {
    return scanState is QrScanStateFound
        ? _buildScannedCode(scanState.transaction.transactionID)
        : _buildScanner();
  }

  Widget _buildScanner() {
    // When haven't located QR Code => generate scanner
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Generate Scanner with the help of 3rd lib
          QRView(
            key: qrKey,
            onQRViewCreated: (r) => _onQRViewCreated(r, context),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
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
                  onPressed: () {},
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
      ),
    );
  }

  List<Widget> _buildScannedCode(String transactionID) {
    return <Widget>[
      Center(
        child: Container(
          width: 250,
          height: 250,
          child: QrImage(
            data: transactionID,
            version: QrVersions.auto,
            size: 200,
            gapless: false,
          ),
        ),
      ),
    ];
  }
}
