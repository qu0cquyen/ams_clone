import 'package:flutter/material.dart';

Widget _indicator(bool isActive) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    height: isActive ? 13.0 : 10.0,
    width: isActive ? 24.0 : 16.0,
    decoration: BoxDecoration(
      color: isActive ? Colors.black : Colors.grey[400],
      shape: BoxShape.circle,
    ),
  );
}

List<Widget> buildPageIndicator({@required int currentPage}) {
  List<Widget> list = [];
  for (int i = 0; i < 3; i++) {
    list.add(i == currentPage ? _indicator(true) : _indicator(false));
  }

  return list;
}

Widget buildContentPage(
    {@required String imgLink,
    @required String title,
    @required String content}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 300.0,
          child: Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}
