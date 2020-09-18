import 'package:flutter/material.dart';

class HelperScreen extends StatelessWidget {
  Widget _buildStepLabel({@required String step, @required title}) {
    return Row(
      // Build Circle Step 1
      children: <Widget>[
        _buildCircle(step: step),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(title,
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildCircle({@required String step}) {
    return Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Text(step,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)));
  }

  Widget _buildDivider({@required double height}) {
    return Padding(
      padding: const EdgeInsets.only(left: 49.0),
      child: Container(width: 2.5, height: height, color: Colors.black),
    );
  }

  Widget _buildSubContent(
      {@required double height, @required String subContent, String imgLink}) {
    return Row(
      children: <Widget>[
        _buildDivider(height: height),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(subContent),
                imgLink != null
                    ? Container(
                        child: Image.network(imgLink),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("How To Pay",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Build First Content
            Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 30.0),
                child: _buildStepLabel(
                    step: "1", title: "Find the merchant's QR code")),
            _buildSubContent(
                height: 120.0,
                subContent: "The QR code will be at the counter"),

            // Build Second Content
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: _buildStepLabel(step: "2", title: "Scan QR Code to Pay"),
            ),
            _buildSubContent(
                height: 120.0,
                subContent: "Tap \"Scanner\" button to start scanning"),

            // Build Third Content
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: _buildStepLabel(step: "3", title: "Enter the amount"),
            ),
            _buildSubContent(
                height: 0.0, subContent: "Ensure to enter the correct amount"),
          ],
        ),
      ),
    );
  }
}
