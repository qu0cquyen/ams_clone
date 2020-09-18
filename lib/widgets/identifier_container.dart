import 'package:flutter/material.dart';

Widget IdentifierContainer({@required String title, @required String owner}) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 15.0)),
          SizedBox(
            height: 5.0,
          ),
          Text(owner,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
