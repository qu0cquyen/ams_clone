import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BottomPopUpCardInfo extends StatefulWidget {
  final String header;
  final String clickAbleSubHeader;
  final bool hasTrailing;
  final Map<String, dynamic> cardPref;
  final List<Map<String, dynamic>> lstItem;
  final VoidCallback onClickHeader;
  final Function(Map<String, dynamic> prefCard) onCardPrefChanged;

  const BottomPopUpCardInfo({
    @required this.header,
    this.clickAbleSubHeader = "",
    this.hasTrailing = false,
    this.cardPref,
    @required this.lstItem,
    this.onClickHeader,
    this.onCardPrefChanged,
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
    if (widget.cardPref != null &&
        item["cardNumber"] == widget.cardPref["cardNumber"])
      _currentSelected = index;

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
            trailing: _currentSelected == index
                ? Icon(Icons.check, color: Colors.green[700])
                : null,
            onTap: () {
              setState(() {
                _currentSelected = index;
              });

              widget.onCardPrefChanged(item);
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
