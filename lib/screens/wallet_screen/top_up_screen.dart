import 'dart:async';

import 'package:ams/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class TopUpScreen extends StatefulWidget {
  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = new TextEditingController();

  String _amountStatus = "Enter Topup Value";
  bool _isKeyBoardVisibile = false;
  StreamSubscription keyboardStream;

  @override
  void initState() {
    super.initState();

    keyboardStream = KeyboardVisibility.onChange.listen((visible) {
      setState(() {
        _isKeyBoardVisibile = visible;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    keyboardStream?.cancel();
    super.dispose();
  }

  List<Widget> _buildInstantPriceBar() {
    int _initPrice = 5;
    List<Widget> _lstInstantPrice = [];
    for (int i = 0; i < 4; i++) {
      String _price = (_initPrice * (i + 1)).toString();
      _lstInstantPrice.add(
        FlatButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            '\$$_price',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          onPressed: () {
            setState(() {
              _amountController.text = '\$$_price';
            });
          },
        ),
      );
    }
    return _lstInstantPrice;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            'Topup',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    child: IdentifierContainer(
                        title: "Account Holder", owner: "Anna Johnston"),
                  ),
                  Text(
                    _amountStatus,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: 120.0,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: _amountController,
                      autofocus: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 50.0,
                      ),
                      onChanged: (val) {},
                    ),
                  ),
                ],
              ),
            ),
            _isKeyBoardVisibile
                ? Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60.0,
                      color: Colors.grey[700],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildInstantPriceBar(),
                      ),
                    ),
                  )
                : !_isKeyBoardVisibile && _amountController.text != ""
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 30.0,
                          ),
                          child: Container(
                            height: 40.0,
                            width: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.black,
                              child: Text(
                                'Confirm Payment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
