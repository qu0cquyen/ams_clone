import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomPopUpCardInfo extends StatefulWidget {
  final String header;
  final String clickAbleSubHeader;
  final bool hasTrailing;
  final List<Map<String, dynamic>> lstItem;
  final VoidCallback onClickHeader;
  final Function(bool isSelected) onSelected;

  const BottomPopUpCardInfo({
    @required this.header,
    this.clickAbleSubHeader = "",
    @required this.hasTrailing,
    @required this.lstItem,
    this.onClickHeader,
    this.onSelected,
  });

  @override
  _BottomPopUpCardInfoState createState() => _BottomPopUpCardInfoState();
}

class _BottomPopUpCardInfoState extends State<BottomPopUpCardInfo> {
  int _currentSelected;
  SlidableController _slideController = SlidableController();
  final GlobalKey<AnimatedListState> _animatedListState = GlobalKey();

  // Animate item gets deleted
  void _deleteItem(int index) {
    var item = widget.lstItem.removeAt(index);
    _animatedListState.currentState.removeItem(index, (context, animation) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
        child: SizeTransition(
          sizeFactor:
              CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
          axisAlignment: 0.0,
          child: _buildItem(item),
        ),
      );
    });
  }

  // Build a specific item
  Widget _buildItem(Map<String, dynamic> item, [int index]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: Slidable(
          key: Key(item["cardNumber"]),
          controller: _slideController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            leading: Icon(Icons.image),
            title: Text(item["cardNumber"]),
            subtitle: Text('\$' + item["balance"].toString()),
            trailing: !widget
                    .hasTrailing // If having trailing icon is false, then build out selecting features
                ? _currentSelected ==
                        index // Check if the currentIndex == index - if it does => include check icon as trailing
                    ? Icon(Icons.check, color: Colors.green[700])
                    : null
                : null, // Otherwise, build Slidable with remove feature
            onTap: () async {
              // If having trailing icon is false, then we need to monitor the current clicked index
              // And change the value of currentSelected index.

              final _prefs = await SharedPreferences.getInstance();
              setState(
                () {
                  _currentSelected = index;
                  // Save value to shared pref
                  _prefs.setString("preferred_card", jsonEncode(item));

                  if (widget.onSelected != null) {
                    widget.onSelected(true);
                  }
                },
              );
            },
          ),
          dismissal: SlidableDismissal(
            // This will help us disappear the item we wanted to delete
            child: SlidableDrawerDismissal(),
            //onDismissed: (actionType) => print("Item has been deleted"),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                setState(
                  () {
                    _deleteItem(index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.header,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  child: Text(
                    widget.clickAbleSubHeader,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                  onPressed: widget.onClickHeader,
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 2.0,
        ),
        Expanded(
          flex: 1,
          child: AnimatedList(
            key: _animatedListState,
            initialItemCount: widget.lstItem.length,
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                opacity: animation,
                child: _buildItem(widget.lstItem[index], index),
              );
            },
          ),
        ),
      ],
    );
  }
}

// class _BottomPopUpInfoState extends State<BottomPopUpInfo> {
//   int _currentSelected;

//   ListTile _buildListTile(String title, String subtitle, bool isTrailing,
//       Icon leading, Icon trailing, int index) {
//     return ListTile(
//       leading: leading,
//       trailing: isTrailing
//           ? IconButton(
//               icon: trailing,
//               onPressed: () {},
//             )
//           : _currentSelected == index
//               ? Icon(Icons.check, color: Colors.green[700])
//               : null,
//       title: Text(title),
//       subtitle: Text(subtitle),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           flex: 0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.header,
//                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                 ),
//                 widget.isIconClickAble
//                     ? IconButton(
//                         icon: widget.icon,
//                         onPressed: widget.onClickHeader,
//                       )
//                     : FlatButton(
//                         child: Text(
//                           widget.clickAbleText,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.blue),
//                         ),
//                         onPressed: widget.onClickHeader,
//                       ),
//               ],
//             ),
//           ),
//         ),
//         Divider(
//           thickness: 2.0,
//         ),
//         Expanded(
//           flex: 1,
//           child: ListView.builder(
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(width: 1),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: widget.isClickable
//                       ? InkWell(
//                           onTap: () {
//                             setState(() {
//                               _currentSelected = index;
//                             });
//                           },
//                           child: _buildListTile(
//                             widget.title,
//                             widget.subTitle,
//                             widget.isTrailing,
//                             widget.leading,
//                             widget.trailing,
//                             index,
//                           ),
//                         )
//                       : _buildListTile(
//                           widget.title,
//                           widget.subTitle,
//                           widget.isTrailing,
//                           widget.leading,
//                           widget.trailing,
//                           index,
//                         ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// Widget buildBottomPopUpInfo({
//   @required String header,
//   String clickAbleText,
//   @required bool isIconClickAble,
//   @required bool isTrailing,
//   Icon icon,
//   String title,
//   String subTitle,
//   Icon leading,
//   Icon trailing,
//   Function onClickHeader,
//   Function onTap,
// }) {
//   clickAbleText ??= "";
//   title ??= "";
//   subTitle ??= "";

//   int _currentSelected = 0;
//   return Column(
//     children: [
//       Expanded(
//         flex: 0,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 header,
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//               isIconClickAble
//                   ? IconButton(
//                       icon: icon,
//                       onPressed: onClickHeader,
//                     )
//                   : FlatButton(
//                       child: Text(
//                         clickAbleText,
//                         style: TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.blue),
//                       ),
//                       onPressed: onClickHeader,
//                     ),
//             ],
//           ),
//         ),
//       ),
//       Divider(
//         thickness: 2.0,
//       ),
//       Expanded(
//         flex: 1,
//         child: ListView.builder(
//           itemCount: 3,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 1),
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     _currentSelected = index;
//                   },
//                   child: ListTile(
//                     leading: leading,
//                     trailing: isTrailing
//                         ? trailing
//                         : _currentSelected == index ? Icon(Icons.check) : null,
//                     title: Text(title),
//                     subtitle: Text(subTitle),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }
